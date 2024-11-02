terraform {
  backend "s3" {
    bucket         = "terraform-state-development-636655795335"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table-development"
    encrypt        = true
  }
}