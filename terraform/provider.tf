terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = var.aws_s3_bucket_name
    key    = "terraform.tfstate"
    region = "eu-west-2"
    encrypt      = true  
    dynamodb_table = var.aws_dynamodb_table_name
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}


