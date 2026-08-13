###############################################
# Busca a AMI mais recente do Amazon Linux 2023
###############################################

data "aws_ami" "amazon_linux" {

  # Sempre retorna a AMI mais recente encontrada
  most_recent = true

  # Busca apenas imagens oficiais publicadas pela Amazon
  owners = ["amazon"]

  # Filtra pelo nome da imagem
  filter {
    name = "name"

    # O * significa "qualquer versão"
    # Exemplo:
    # al2023-ami-2023.5-x86_64
    # al2023-ami-2023.6-x86_64
    values = ["al2023-ami-*-x86_64"]
  }

  # Considera somente imagens disponíveis
  filter {
    name   = "state"
    values = ["available"]
  }
}

###############################################
# Security Group
###############################################

resource "aws_security_group" "web_sg" {
  #nome que aparecerá na AWS
  name        = "${var.project_name}-sg"
  description = "Permite acesso HTTP"

  # regras de entrada 

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  #regras de saída

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

###############################################
# EC2
###############################################

resource "aws_instance" "web_server" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  # Script executado na primeira inicialização
  user_data = <<-EOF
#!/bin/bash
dnf update -y
dnf install nginx -y
systemctl enable nginx
systemctl start nginx

mkdir -p /var/www/html

cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>ShopCloud</title>
</head>
<body>
  <h1>ShopCloud</h1>
  <p>Servidor criado com Terraform 🚀</p>
</body>
</html>
HTML
EOF

  tags = {
    Name = var.project_name
  }
}