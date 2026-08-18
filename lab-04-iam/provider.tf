provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Lab = "lab-04-iam"
    }
  }
}