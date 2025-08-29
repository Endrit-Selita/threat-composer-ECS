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

# Create Route 53
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "example.com"
  type    = "A"

  alias {
    name                   = ###aws_lb.main.dns_name
    zone_id                = ###aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

# Create a VPC
resource "aws_vpc" "vpc-ecs" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_internet_gateway" "i-gateway" {
  vpc_id = aws_vpc.vpc-ecs.id

  tags = {
    Name = "gw"
  }
}

# availability Zone 1
data "aws_availability_zones" "az1" {
  state = "available"
}

# public subnet 1
resource "aws_subnet" "public1" {
  cidr_block              = "10.11.0.0/24"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
}

# NAT gateway - public subnet 1
resource "aws_nat_gateway" "nat-gw1" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id
}

# availability Zone 2
data "aws_availability_zones" "az2" {
  state = "available"
}

# Public subnet 2
resource "aws_subnet" "public2" {
  cidr_block              = "10.12.0.0/24"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]
}

# NAT gateway - public subnet 2
resource "aws_nat_gateway" "nat-gw2" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public2.id
}

# ALB
resource "aws_lb" "alb-ecs" {
  name               = "alb-ecs"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [ 
    aws_subnet.public1.id,
    aws_subnet.public2.id,
]

  enable_deletion_protection = true

  access_logs {
    bucket  = ###aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }
}

# private subnet 1
resource "aws_subnet" "private1" {
  cidr_block              = "10.13.0.0/24"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = "false"
}

