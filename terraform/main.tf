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
alb-ecs-load_balancer_type = var.alb-ecs-load_balancer_type 
alb-ecs_public_subnets = module.vpc.public_subnets_id # this refernces the public_subnets output from the vpc module
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

module "BAckend" {
  source = "./modules/Backend"

aws_s3_bucket_name = var.aws_s3_bucket_name
aws_dynamodb_table_name = var.aws_dynamodb_table_name
aws_dynamodb_table_hash_key = var.aws_dynamodb_table_hash_key
aws_dynamodb_table_read_capacity = var.aws_dynamodb_table_read_capacity
aws_dynamodb_table_write_capacity = var.aws_dynamodb_table_write_capacity
aws_dynamodb_table_attribute_name = var.aws_dynamodb_table_attribute_name
aws_dynamodb_table_attribute_type = var.aws_dynamodb_table_attribute_type
}

module "ECR" {
  source = "./modules/ECR"

  aws_ecr_repository_name = var.aws_ecr_repository_name
  aws_ecr_repository_image_tag_mutability = var.aws_ecr_repository_image_tag_mutability
  ecr_scan_on_push = var.ecr_scan_on_push
}

module "ECS" {
  source = "./modules/ECS"

  ecs_cluster_name= var.ecs_cluster_name
  ecs_logging= var.ecs_logging
  cloud_watch_encryption= var.cloud_watch_encryption
  cloud_watch_name= var.cloud_watch_name
  deletion_window= var.deletion_window
  iam_policy_action= var.iam_policy_action
  principals_type= var.principals_type
  principals_identifiers=var.principals_identifiers
  ecs_iam_role_name= var.ecs_iam_role_name
  ecs_iam_role_assume_role_policy= var.ecs_iam_role_assume_role_policy
  ecs_exec_attach_policy_arn= var.ecs_exec_attach_policy_arn
  ecs_service_family = var.ecs_service_family
  ecs_service_requires_compatibilities= var.ecs_service_requires_compatibilities
  ecs_service_network_mode = var.ecs_service_network_mode 
  ecs_service_cpu = var.ecs_service_cpu
  ecs_service_memory= var.ecs_service_memory
  con_def_name= var.con_def_name
  con_def_cpu = var.con_def_cpu
  ecs_service_name= var.ecs_service_name
  ecs_service_launch_type= var.ecs_service_launch_type
  ecs_service_platform_version= var.ecs_service_platform_version
  ecs_service_desired_count = var.ecs_service_desired_count
  ecs_load_balancer_container_name= var.ecs_load_balancer_container_name
  ecs_load_balancer_container_port= var.ecs_load_balancer_container_port
  ecs_network_configuration_apip= var.ecs_network_configuration_apip
  ecs_network_configuration_subnets = module.vpc.private_subnets_id
  ecs_sg_name= var.ecs_sg_name
  ecs_sg_ingress_from_port= var.ecs_sg_ingress_from_port
  ecs_sg_ingress_to_port= var.ecs_sg_ingress_to_port
  ecs_sg_ingress_protocol= var.ecs_sg_ingress_protocol
  ecs_sg_egress_from_port= var.ecs_sg_egress_from_port
  ecs_sg_egress_to_port= var.ecs_sg_egress_to_port
  ecs_sg_egress_protocol= var.ecs_sg_egress_protocol
  ecs_sg_egress_cidr_blocks= var.ecs_sg_egress_cidr_blocks
  target_group_arn = module.alb.target_group_arn_id
  vpc_id_ecs_sg = module.vpc.vpc-ecs_id.id
  ecs_ingress_security_groups = module.ALB.alb_security_group_id.id
}