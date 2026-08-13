variable "aws_region" {
  description = "Região onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto utilizado em tags e recursos."
  type        = string
  default     = "lab-01-ec2-nginx"
}

variable "instance_type" {
  description = "Tipo da instância EC2."
  type        = string
  default     = "t3.micro"
}