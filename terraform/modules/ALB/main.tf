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

resource "aws_lb_target_group" "albtargetgroup" {
  name        = "albtargetgroup"
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

