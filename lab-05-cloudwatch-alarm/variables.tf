variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "email_alerta" {
  description = "Email que receberá os alertas"
  type        = string
}

variable "lambda_name" {
  description = "Lambda monitorada pelo CloudWatch"

  type    = string
  default = "lab-03-lambda-api-function"
}

variable "threshold" {
  description = "Quantidade de erros para disparar o alarm"

  type    = number
  default = 1
}