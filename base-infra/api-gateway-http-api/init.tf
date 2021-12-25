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