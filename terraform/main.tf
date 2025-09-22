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

# S3 Bucket
terraform {
  backend "s3" {
    bucket = "mys3bucket"
    key    = "terraform.tfstate"
    region = "eu-west-2"
    encrypt      = true  
    use_lockfile = true
  }
}

# Create Route 53
################ need to fix godaddy to make this work
resource "aws_route53_zone" "r53_zone" {
  name = "normanbrown.co.uk"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = "tm.normanbrown.co.uk"
  type    = "A"

  alias {
    name                   = aws_lb.alb-ecs.dns_name
    zone_id                = aws_lb.alb-ecs.zone_id
    evaluate_target_health = true
  }
}

# Create a VPC
resource "aws_vpc" "vpc-ecs" {
  cidr_block = "10.10.0.0/16"
}

# Interet Gateway
resource "aws_internet_gateway" "i-gateway" {
  vpc_id = aws_vpc.vpc-ecs.id

  tags = {
    Name = "gw"
  }
}

# availability Zone 
data "aws_availability_zones" "az" {
  state = "available"
}

# public subnet 1
resource "aws_subnet" "public1" {
  cidr_block              = "10.11.0.0/16"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.az.names[0]
}

 # Elastic IP for Nat gateway in public subnet 1
resource "aws_eip" "eip1" {
  domain   = "vpc"
}

# NAT gateway - public subnet 1
resource "aws_nat_gateway" "nat-gw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public1.id
}

# Public subnet 2
resource "aws_subnet" "public2" {
  cidr_block              = "10.12.0.0/16"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.az.names[1]
}

 # Elastic IP for Nat gateway in public subnet 2
resource "aws_eip" "eip2" {
  domain   = "vpc"
}

# NAT gateway - public subnet 2
resource "aws_nat_gateway" "nat-gw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public2.id
}

# ALB
resource "aws_lb" "alb-ecs" {
  name               = "alb-ecs"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [ 
    aws_subnet.public1.id,
    aws_subnet.public2.id]

  enable_deletion_protection = true
}

resource "aws_lb_target_group" "alb_targetgroup" {
  name        = "alb_targetgroup"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc-ecs.id

health_check {
  enabled = true
  interval = 30
  path = "/"
  port = "traffic-port"
  protocol = "HTTP"
  timeout = 5
  healthy_threshold = 3
  unhealthy_threshold = 3
  matcher = "200-299"
}
}

resource "aws_lb_listener" "HTTPS_l" {
  load_balancer_arn = aws_lb.alb-ecs.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.acm_cert.arn
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_targetgroup.arn
  }
}

resource "aws_lb_listener" "HTTP_1" {
  load_balancer_arn = aws_lb.alb-ecs.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc-ecs.id
  tags = {
    Name = "alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_http" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_https" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}
resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_acm_certificate" "acm_cert" {
  domain_name       = "tm.normanbrown.co.uk"
  validation_method = "DNS"
}

# private subnet 1 in AZ1
resource "aws_subnet" "private1" {
  cidr_block              = "10.13.0.0/16"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.az.names[0]
}

# private subnet 2 in AZ2
resource "aws_subnet" "private2" {
  cidr_block              = "10.14.0.0/16"
  vpc_id                  = aws_vpc.vpc-ecs.id
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.az.names[1]
}

############# Creating ECS ##########################

# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.kms_key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cloudwatch.name
      }
    }
  }
}

# cloud watch
resource "aws_cloudwatch_log_group" "ecs_cloudwatch" {
  name = "ecs_cloudwatch"
}

#KMS Keys
resource "aws_kms_key" "kms_key" {
  description             = "kms_key"
  deletion_window_in_days = 7
}

#ECS Task Defenition
resource "aws_ecs_task_definition" "service" {
  family = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "service-first"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name      = "second"
      image     = "service-second"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

resource "aws_ecs_service" "mongo" {
  name            = "mongodb"
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  cluster         = aws_ecs_cluster.ecs-c1.id
  task_definition = aws_ecs_task_definition.mongo.arn
  desired_count   = 2
  iam_role        = aws_iam_role.foo.arn
  depends_on      = [aws_iam_role_policy.foo]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "latest-container"
    container_port   = 443
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = 
    subnets          = [aws_subnet.private1.id, aws_subnet.private2.id]
  }
}


  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }

}

# ECR 
resource "aws_ecr_repository" "ecr_app" {
  name                 = "ecr_app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# route table internet gateway
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc-ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i-gateway.id
  }