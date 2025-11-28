############### ALB ###############
resource "aws_lb" "alb-ecs" {
  name               = var.alb-ecs-name
  internal           = var.alb-ecs-internal
  load_balancer_type = var.alb-ecs-load_balancer_type
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.alb-ecs_public_subnets

  enable_deletion_protection = var.alb-ecs-enable_deletion_protection
}

resource "aws_lb_target_group" "albtargetgroup" {
  name        = var.aws_lb_target_group_name
  port        = var.aws_lb_target_group_port
  protocol    = var.aws_lb_target_group_protocol
  target_type = var.aws_lb_target_group_target_type
  vpc_id      = var.albtargetgroup_vpc_id

  health_check {
    enabled             = var.health_check_enabled
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }
}

resource "aws_lb_listener" "HTTPS_l" {
  load_balancer_arn = aws_lb.alb-ecs.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.HTTPS_l_ssl_policy
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.albtargetgroup.arn
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
  name        = var.aws_security_group_name
  description = "ALB Security Group"
  vpc_id      = var.albtargetgroup_vpc_id
  tags = {
    Name = "alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_http" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = var.alb_ingress_http_cidr_ipv4
  from_port   = var.alb_ingress_http_from_port
  ip_protocol = var.alb_ingress_http_ip_protocol
  to_port     = var.alb_ingress_http_to_port
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_https" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = var.alb_ingress_https_cidr_ipv4
  from_port   = var.alb_ingress_https_from_port
  ip_protocol = var.alb_ingress_https_ip_protocol
  to_port     = var.alb_ingress_https_to_port
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = var.alb_egress_cidr_ipv4
  ip_protocol       = var.alb_egress_ip_protocol
}

