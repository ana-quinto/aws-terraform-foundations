variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "nome_usuario" {
  description = "Nome do usuário IAM"
  type        = string
  default     = "dev-junior"
}

variable "nome_grupo" {
  description = "Nome do grupo IAM"
  type        = string
  default     = "desenvolvedores"
}