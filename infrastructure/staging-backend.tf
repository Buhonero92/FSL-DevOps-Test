terraform {
  backend "s3" {
    bucket         = "terraform-state-staging-636655795335"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table-staging"
    encrypt        = true
  }
}