#### ACM ####

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

#### ALB ####
variable "alb-ecs-name" {
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