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

resource "aws_eks_cluster" "dl-my-cluster" {
  name     = "dl-my-cluster"
  role_arn = aws_iam_role.dl-aws-iam-role.arn

  vpc_config {
    subnet_ids = [aws_subnet.main.id]
  }
}

resource "aws_iam_role" "dl-aws-iam-role" {
  name = "dl-eks-cluster-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}