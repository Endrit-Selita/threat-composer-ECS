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
          containerPort = 80,
          hostPort      = 80
        }
      ]

    logConfiguration = {
      logDriver                 = "awslogs",
      options = {
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
    target_group_arn = aws_lb_target_group.albtargetgroup.id
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
