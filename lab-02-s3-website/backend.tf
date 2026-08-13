terraform {
  backend "s3" {
    bucket = "states-ana-lab-terraform"
    key    = "lab-02-s3-website/terraform.tfstate"
    region = "us-east-1"
  }
}
