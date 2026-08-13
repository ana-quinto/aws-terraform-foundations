terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    #Empacotando o código python
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}