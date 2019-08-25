provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

terraform {
  required_version = ">= 0.12"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "s3-prod-state-shared-2019"

  # Enable versioning 
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
