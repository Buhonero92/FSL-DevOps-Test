variable "environment" {
    description = "The environment to deploy the app (devel, stage, prod)"
    type = string
}

variable "region" {
    description = "The AWS region to deploy the app"
    type = string
    default = "us-east-1"
}