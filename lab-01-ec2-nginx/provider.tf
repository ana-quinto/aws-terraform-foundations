provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Lab       = "terraform-foundations"
    }
  }
}