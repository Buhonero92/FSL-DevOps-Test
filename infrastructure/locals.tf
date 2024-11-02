locals {
  account_id = data.aws_caller_identity.current.account_id
  environments = ["development", "staging", "production"]
}