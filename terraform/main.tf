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

############### S3 Bucket ###############
terraform {
  backend "s3" {
    bucket = "mys3bucket"
    key    = "terraform.tfstate"
    region = "eu-west-2"
    encrypt      = true  
    use_lockfile = true
  }
}

############### Create Route 53 ###############
# need to fix godaddy to make this work
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

############### ACM ###############

resource "aws_acm_certificate" "acm_cert" {
  domain_name       = "tm.normanbrown.co.uk"
  validation_method = "DNS"
}

############### Create a VPC ###############
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

# route table internet gateway
resource "aws_route_table" "ig_rt_public" {
  vpc_id = aws_vpc.vpc-ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i-gateway.id
  }
}

#public subnet 1 association to internet gateway route table
resource "aws_route_table_association" "pubsub1-igr" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.ig_rt_public.id
}

#public subnet 2 association to internet gateway route table
resource "aws_route_table_association" "pubsub2-igr" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.ig_rt_public.id
}

# route table NAT Gateway in public subnet 1
resource "aws_route_table" "ng_rt_ecs_1" {
  vpc_id = aws_vpc.vpc-ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw1.id
  }
}

# private subnet 1 association to NAT Gateway route table 1
resource "aws_route_table_association" "prisub1-ngr" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.ng_rt_ecs_1.id
}

# route table NAT Gateway in public subnet 2
resource "aws_route_table" "ng_rt_ecs_2" {
  vpc_id = aws_vpc.vpc-ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw2.id
  }
}

# private subnet 2 association to NAT Gateway route table 2
resource "aws_route_table_association" "prisub2-ngr" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.ng_rt_ecs_2.id
}


############### ALB ###############
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

############### Creating ECS ###############

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

data "aws_iam_policy_document" "ecs_iam_pd" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_iam_role" {
  name               = "instance_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_iam_pd.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
  role       = aws_iam_role.ecs_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
  
#ECS Task Defenition
resource "aws_ecs_task_definition" "service" {
  family = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_iam_role.arn

  container_definitions = jsonencode([
    {
      name      = "tcdf"
      image     = "${aws_ecr_repository.ecr_app.repository_url}:latest"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    logConfiguration = {
      logDriver                 = "awslogs",
      options: {
        awslogs-group           = aws_cloudwatch_log_group.ecs_cloudwatch.name,
        awslogs-region          = "eu-west-2",
        awslogs-stream-prefix   = "ecs"
      }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "ecs_service"
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_targetgroup.id
    container_name   = "tcdf"
    container_port   = 80
  }

  network_configuration {
    assign_public_ip = false
    security_groups = [aws_security_group.ecs_sg.id]
    subnets          = [aws_subnet.private1.id, aws_subnet.private2.id]
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "Allow HTTP inbound traffic from ALB"
  vpc_id      = aws_vpc.vpc-ecs.id

ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      security_groups = [aws_security_group.alb_sg.id]
      }

egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

############### ECR ###############
resource "aws_ecr_repository" "ecr_app" {
  name                 = "ecr_app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}