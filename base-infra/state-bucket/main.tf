terraform {
  backend "local" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64.2"
    }
  }
  required_version = "~> 1.0.0"
}
provider "aws" {
  region = "ap-southeast-1"
}
##############################
# CREATE THE S3 BUCKET
##############################
resource "aws_s3_bucket" "tfstate-bucket" {
  # With account id, this S3 bucket names can be *globally* unique.
  bucket = format("%s-%s-tfstate-bucket", var.a, var.b)

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
#############################
# CREATE THE DYNAMODB TABLE
#############################
resource "aws_dynamodb_table" "tfstate-db" {
  name         = format("%s-%s-tfstate-db", var.a, var.b)
  read_capacity  = 5
  write_capacity = 5
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    name = format("%s-%s-tfstate-db", var.a, var.b)
  }
}
