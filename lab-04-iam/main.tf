# Recupera informações da conta AWS atual
data "aws_caller_identity" "current" {}

# Cria o usuário IAM que será utilizado nos testes
resource "aws_iam_user" "dev_junior" {
  name = var.nome_usuario
}

# Gera Access Key e Secret Key para acesso via AWS CLI
resource "aws_iam_access_key" "dev_junior" {
  user = aws_iam_user.dev_junior.name
}

# Cria o grupo IAM
resource "aws_iam_group" "developers" {
  name = var.nome_grupo
}

# Adiciona o usuário ao grupo
resource "aws_iam_group_membership" "developers" {
  name = "developers-membership"

  users = [
    aws_iam_user.dev_junior.name
  ]

  group = aws_iam_group.developers.name
}

# Policy customizada com acesso somente leitura
# à tabela lab-pedidos criada no Lab 03
resource "aws_iam_policy" "dynamodb_readonly" {
  name        = "dynamodb-readonly-policy"
  description = "Permite leitura da tabela lab-pedidos"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ReadOnlyDynamoDB"
        Effect = "Allow"

        Action = [
          "dynamodb:Scan",
          "dynamodb:GetItem"
        ]

        #Pega o account ID dinamicamente.
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/lab-pedidos"
      }
    ]
  })
}

# Associa a policy ao grupo
resource "aws_iam_group_policy_attachment" "developers" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.dynamodb_readonly.arn
}