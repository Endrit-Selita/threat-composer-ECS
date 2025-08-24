terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

# Setting Up an S3 Backend
terraform {
  backend "s3" {
    bucket = "TC_S3"
    key    = "main.tf"
    region = "eu-west-2"
  }
}


# Create a VPC
resource "aws_vpc" "TC_VPN" {
  cidr_block = "10.0.0.0/16"
}