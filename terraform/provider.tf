terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "mys3bucket-euwest2"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "dynamodb_terraform_lock"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}


