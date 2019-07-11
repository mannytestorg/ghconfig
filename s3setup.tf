# Copyright 2019 Hewlett Packard Enterprise Development LP
# Adapted from https://github.com/hpe-hcss/aws-account-config/blob/master/organizations/s3state.tf

# s3 bucket for root-user state-files.
resource "aws_s3_bucket" "tf_state" {
  bucket = "mannytestorg-tf-state"
  acl    = "private"

  versioning {
    enabled = "true"
  }
}

# DynamoDB lock table
resource "aws_dynamodb_table" "dynamo_db_terraform_state_lock" {
  provider       = aws
  name           = "manny-terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Key for the organizations state file
resource "aws_s3_bucket_object" "ghrepos" {
  bucket = aws_s3_bucket.tf_state.bucket
  acl    = "private"
  key    = "terraform/state/ghrepos"
  source = "/dev/null"
}
