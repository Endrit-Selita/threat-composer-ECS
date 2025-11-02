############### Creating ECS ###############

# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.kms_key.arn
      logging    = var.ecs_logging

      log_configuration {
        cloud_watch_encryption_enabled = var.cloud_watch_encryption
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cloudwatch.name
      }
    }
  }
}

# cloud watch
resource "aws_cloudwatch_log_group" "ecs_cloudwatch" {
  name = var.cloud_watch_name
}

#KMS Keys
resource "aws_kms_key" "kms_key" {
  description             = "kms_key"
  deletion_window_in_days = var.deletion_window
}

data "aws_iam_policy_document" "ecs_iam_pd" {
  statement {
    actions = [var.iam_policy_action]

    principals {
      type        = var.principals_type
      identifiers = [var.principals_identifiers]
    }
  }
}

resource "aws_iam_role" "ecs_iam_role" {
  name               = var.ecs_iam_role_name
  assume_role_policy = var.ecs_iam_role_assume_role_policy
}

resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
  role       = aws_iam_role.ecs_iam_role.name
  policy_arn = var.ecs_exec_attach_policy_arn
}
  
#ECS Task Defenition
resource "aws_ecs_task_definition" "service" {
  family = var.ecs_service_family
  requires_compatibilities = [var.ecs_service_requires_compatibilities]
  network_mode             = var.ecs_service_network_mode
  cpu                      = var.ecs_service_cpu
  memory                   = var.ecs_service_memory
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
  name            = var.ecs_service_name
  launch_type     = var.ecs_service_launch_type
  platform_version = var.ecs_service_platform_version
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.ecs_service_desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.albtargetgroup.id
    container_name   = var.ecs_load_balancer_container_name
    container_port   = var.ecs_load_balancer_container_port
  }

  network_configuration {
    assign_public_ip = var.ecs_network_configuration_apip
    security_groups = [aws_security_group.ecs_sg.id]
    subnets          = var.ecs_network_configuration_subnets
  }
}
 
# carry on below this

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
