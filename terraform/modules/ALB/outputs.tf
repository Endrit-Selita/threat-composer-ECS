output "aws_lb" {
  value = aws_lb.alb-ecs.arn
}

output "alb_dns_name" {
  value = aws_lb.alb-ecs.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb-ecs.zone_id
}

output "alb_listener" {
  value = aws_lb_listener.HTTPS_l.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.albtargetgroup.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}
