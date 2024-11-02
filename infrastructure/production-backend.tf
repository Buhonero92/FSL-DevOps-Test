terraform {
  backend "s3" {
    bucket         = "terraform-state-production-636655795335"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table-production"
    encrypt        = true
  }
}