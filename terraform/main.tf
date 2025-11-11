module "ACM" {
source = "./modules/ACM"

domain_name = var.domain_name
validation_method = var.validation_method
ttl = var.ttl
zone_id = module.route53.zone_id  # this refernces the zone_id output from the route53 module
}

module "ALB" {
  source = "./modules/ALB"

alb-ecs-name = var.alb-ecs-name
alb-ecs-internal = var.alb-ecs-internal
alb-ecs-load_balancer_type = var.alb-ecs-load_balancer_type # this refernces the public_subnets output from the vpc module
alb-ecs_public_subnets = module.vpc.public_subnets_id
acm_certificate_arn = module.ACM.acm_cert_output_arn
alb-ecs-enable_deletion_protection = var.alb-ecs-enable_deletion_protection
albtargetgroup_vpc_id = module.vpc.vpc-ecs_id
aws_lb_target_group_name = var.aws_lb_target_group_name
aws_lb_target_group_port = var.aws_lb_target_group_port
aws_lb_target_group_protocol = var.aws_lb_target_group_protocol
aws_lb_target_group_target_type = var.aws_lb_target_group_target_type
health_check_enabled = var.health_check_enabled
health_check_interval = var.health_check_interval
health_check_path = var.health_check_path
health_check_port = var.health_check_port
health_check_protocol = var.health_check_protocol
health_check_timeout = var.health_check_timeout
health_check_healthy_threshold = var.health_check_healthy_threshold
health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
health_check_matcher = var.health_check_matcher
HTTPS_l_ssl_policy = var.HTTPS_l_ssl_policy
aws_security_group_name = var.aws_security_group_name
alb_ingress_http_cidr_ipv4 = var.alb_ingress_http_cidr_ipv4
alb_ingress_https_cidr_ipv4 = var.alb_ingress_https_cidr_ipv4
alb_ingress_http_from_port = var.alb_ingress_http_from_port
alb_ingress_http_ip_protocol = var.alb_ingress_http_ip_protocol
alb_ingress_http_to_port = var.alb_ingress_http_to_port
alb_ingress_https_from_port = var.alb_ingress_https_from_port
alb_ingress_https_ip_protocol= var. alb_ingress_https_ip_protocol
alb_ingress_https_to_port = var.alb_ingress_https_to_port
alb_egress_cidr_ipv4 = var.alb_egress_cidr_ipv4
alb_egress_ip_protocol = var.alb_egress_ip_protocol
}







