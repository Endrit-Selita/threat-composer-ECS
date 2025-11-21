############### ACM ###############

variable "domain_name" {
  description = "Domain name for ACM certificate"
  type        = string
}

variable "validation_method" {
  description = "validation menthod of the domain name"
  type        = string
}

variable "ttl" {
  description = "How long (in seconds) DNS resolvers can cache a record before querying Route 53 for fresh data"
  type        = number
}

############### ALB ###############
variable "alb-ecs-name"{
  type        = string
}

variable "alb-ecs-internal" {
  type        = bool
}

variable "alb-ecs-load_balancer_type" {
  type        = string
}

variable "alb-ecs-enable_deletion_protection" {
  type        = bool
}

variable "aws_lb_target_group_name" {
  type        = string
}

variable "aws_lb_target_group_port" {
  type        = number
}

variable "aws_lb_target_group_protocol" {
  type        = string
}

variable "aws_lb_target_group_target_type" {
  type        = string
}

variable "health_check_enabled" {
  type        = bool
}

variable "health_check_interval" {
  type        = number
}

variable "health_check_path" {
  type        = string
}

variable "health_check_port" {
  type        = string
}

variable "health_check_protocol" {
  type        = string
}

variable "health_check_timeout" {
  type        = number
}

variable "health_check_healthy_threshold" {
  type        = number
}

variable "health_check_unhealthy_threshold" {
  type        = number
}

variable "health_check_matcher" {
  type        = string
}

variable "HTTPS_l_ssl_policy" {
  type = string
}

variable "aws_security_group_name" {
  type = string
}

variable "alb_ingress_http_cidr_ipv4" {
  type = string
}

variable "alb_ingress_http_from_port" {
  type = number
}

variable "alb_ingress_http_ip_protocol" {
  type = string
}

variable "alb_ingress_http_to_port" {
  type = number
}

variable "alb_ingress_https_cidr_ipv4" {
  type = string
}

variable "alb_ingress_https_from_port" {
  type = number
}

variable "alb_ingress_https_ip_protocol" {
  type = string
}

variable "alb_ingress_https_to_port" {
  type = number
}

variable "alb_egress_cidr_ipv4" {
  type = string
}

variable "alb_egress_ip_protocol" {
  type = string
}

############### BAckend ###############
variable "aws_s3_bucket_name" {
  type = string
}

variable "aws_dynamodb_table_name" {
  type = string
}

variable "aws_dynamodb_table_hash_key" {
  type = string
}

variable "aws_dynamodb_table_read_capacity" {
  type = number
}

variable "aws_dynamodb_table_write_capacity" {
  type = number
}

variable "aws_dynamodb_table_attribute_name" {
  type = string
}

variable "aws_dynamodb_table_attribute_type" {
  type = string
}

############### ECR ###############
variable "aws_ecr_repository_name" {
    type = string
}

variable "aws_ecr_repository_image_tag_mutability" {
    type = string
}

variable "ecr_scan_on_push" {
    type = bool
}

############### ECS ###############

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_logging" {
  type = string
}

variable "cloud_watch_encryption" {
  type = bool
}

variable "cloud_watch_name" {
  type = string
}

variable "deletion_window" {
  type = number
}

variable "iam_policy_action" {
  type = string
}

variable "principals_type" {
  type = string
}

variable "principals_identifiers" {
  type = string
}

variable "ecs_iam_role_name" {
  type = string
}

variable "ecs_iam_role_assume_role_policy" {
  type = string
}

variable "ecs_exec_attach_policy_arn" {
  type = string
}

variable "ecs_service_family" {
  type = string
}

variable "ecs_service_requires_compatibilities" {
  type = string
}

variable "ecs_service_network_mode" {
  type = string
}

variable "ecs_service_cpu" {
  type = number
}

variable "ecs_service_memory" {
  type = number
}

variable "con_def_name" {
  type = string
}

variable "con_def_cpu" {
  type = number
}

variable "ecs_service_name" {
  type = string
}

variable "ecs_service_launch_type" {
  type = string
}

variable "ecs_service_platform_version" {
  type = string
}

variable "ecs_service_desired_count" {
  type = number
}

variable "ecs_load_balancer_container_name" {
  type = string
}

variable "ecs_load_balancer_container_port" {
  type = number
}

variable "ecs_network_configuration_apip" {
  type = bool
}

variable "ecs_sg_name" {
  type = string
}

variable "ecs_sg_ingress_from_port" {
  type = number
}

variable "ecs_sg_ingress_to_port" {
  type = number
}

variable "ecs_sg_ingress_protocol" {
  type = string
}

variable "ecs_sg_egress_from_port" {
  type = number
}

variable "ecs_sg_egress_to_port" {
  type = number
}

variable "ecs_sg_egress_protocol" {
  type = string
}

variable "ecs_sg_egress_cidr_blocks" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "vpc_id_ecs_sg" {
  type = string
}

variable "ecs_ingress_security_groups" {
  type = string
}

############### Route 53 ###############

variable "aws_route53_zone_name" {
  type = string
}

variable "aws_route53_record_name" {
  type = string
}

variable "aws_route53_record_type" {
  type = string
}

variable "aws_route53_alias_evaluate_target_health" {
  type = bool
}

variable "alias_target_dns_name" {
  type = string
}

variable "alias_target_zone_id" {
  type = string
}

############### VPC ###############

variable "vpc-ecs_cider_block" {
    type = string
}

variable "az_state" {
    type = string
}

variable "public_subnet_1_cidr_block" {
    type = string
}

variable "public_subnet_1_map_public_ip_on_launch" {
    type = bool
}

variable "eip1_domain" {
    type = string
}

variable "public_subnet_2_cidr_block" {
    type = string
}

variable "public_subnet_2_map_public_ip_on_launch" {
    type = bool
}

variable "eip2_domain" {
    type = string
}

variable "private_subnet_1_cidr_block" {
    type = string
}

variable "private_subnet_1_map_public_ip_on_launch" {
    type = bool
}

variable "private_subnet_2_cidr_block" {
    type = string
}

variable "private_subnet_2_map_public_ip_on_launch" {
    type = bool
}

variable "ig_rt_public_cidr_block" {
    type = string
}

variable "ng_rt_ecs_1_cidr_block" {
    type = string
}

variable "ng_rt_ecs_2_cidr_block" {
    type = string
}