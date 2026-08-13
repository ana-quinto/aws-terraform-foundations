# ------------------------------------------------------------------
# DynamoDB
# ------------------------------------------------------------------

resource "aws_dynamodb_table" "pedidos" {
  name         = "lab-pedidos"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
resource "aws_dynamodb_table_item" "pedido_1" {
  table_name = aws_dynamodb_table.pedidos.name
  hash_key   = aws_dynamodb_table.pedidos.hash_key

  item = jsonencode({
    id       = { S = "1" }
    cliente  = { S = "Ana" }
    produto  = { S = "Notebook" }
    status   = { S = "PROCESSANDO" }
  })
}

resource "aws_dynamodb_table_item" "pedido_2" {
  table_name = aws_dynamodb_table.pedidos.name
  hash_key   = aws_dynamodb_table.pedidos.hash_key

  item = jsonencode({
    id       = { S = "2" }
    cliente  = { S = "João" }
    produto  = { S = "Mouse" }
    status   = { S = "ENVIADO" }
  })
}

# ------------------------------------------------------------------
# IAM Role da Lambda
# ------------------------------------------------------------------

resource "aws_iam_role" "lambda" {
  name = "${var.nome_projeto}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

# ------------------------------------------------------------------
# Permissões básicas para CloudWatch Logs
# ------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ------------------------------------------------------------------
# Permissão para leitura da tabela DynamoDB
# ------------------------------------------------------------------

resource "aws_iam_role_policy" "dynamodb_access" {
  name = "${var.nome_projeto}-dynamodb"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "dynamodb:GetItem",
        "dynamodb:Scan"
      ]

      Resource = aws_dynamodb_table.pedidos.arn
    }]
  })
}

# ------------------------------------------------------------------
# CloudWatch Logs
# ------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.nome_projeto}-function"
  retention_in_days = 7
}

# ------------------------------------------------------------------
# Empacotando o código Python
# ------------------------------------------------------------------

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/src/api_pedidos.py"
  output_path = "${path.module}/.build/api_pedidos.zip"
}

# ------------------------------------------------------------------
# Lambda
# ------------------------------------------------------------------

resource "aws_lambda_function" "api_pedidos" {
  function_name = "${var.nome_projeto}-function"

  role = aws_iam_role.lambda.arn

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"
  handler = "api_pedidos.lambda_handler"

  timeout     = 10
  memory_size = 128

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.pedidos.name
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy.dynamodb_access,
    aws_cloudwatch_log_group.lambda
  ]
}

# ------------------------------------------------------------------
# Function URL
# ------------------------------------------------------------------

resource "aws_lambda_function_url" "api" {
  function_name      = aws_lambda_function.api_pedidos.function_name
  authorization_type = "NONE"
}
# Permite que qualquer pessoa invoque a Function URL.
# Sem essa permissão a URL é criada, mas retorna "Forbidden".
resource "aws_lambda_permission" "function_url" {
  statement_id           = "AllowPublicAccess"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.api_pedidos.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}
# A Function URL precisa de permissões para acesso público.
# Em alguns cenários, apenas InvokeFunctionUrl não é suficiente.
# Esta permissão garante que a função possa ser executada pela URL.
resource "aws_lambda_permission" "invoke_function" {
  statement_id  = "AllowInvokeFunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_pedidos.function_name
  principal     = "*"
}