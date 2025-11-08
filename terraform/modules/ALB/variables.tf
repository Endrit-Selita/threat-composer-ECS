variable "alb-ecs-name" {
  type        = string
  default     = "alb-ecs"
}

variable "alb-ecs-internal" {
  type        = bool
  default     = false
}

variable "alb-ecs-load_balancer_type" {
  type        = string
  default     = "application"
}

variable "alb-ecs_public_subnets" {
  type = list(string)
}

variable "alb-ecs-enable_deletion_protection" {
  type        = bool
  default     = false
}

variable "aws_lb_target_group_name" {
  type        = string
  default     = "albtargetgroup"
}

variable "aws_lb_target_group_port" {
  type        = number
  default     = 80
}

variable "aws_lb_target_group_protocol" {
  type        = string
  default     = "HTTP"
}

variable "aws_lb_target_group_target_type" {
  type        = string
  default     = "ip"
}

variable "health_check_enabled" {
  type        = bool
  default     = true
}

variable "health_check_interval" {
  type        = number
  default     = 30
}

variable "health_check_path" {
  type        = string
  default     = "/"
}

variable "health_check_port" {
  type        = string
  default     = "traffic-port"
}

variable "health_check_protocol" {
  type        = string
  default     = "HTTP"
}

variable "health_check_timeout" {
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  type        = string
  default     = "200-299"
}

variable "HTTPS_l_ssl_policy" {
  type = string
  default = "ELBSecurityPolicy-2016-08"
}

variable "aws_security_group_name" {
  type = string
  default = "alb_sg"
}

variable "alb_ingress_http_cidr_ipv4" {
  type = string
  default = "0.0.0.0/0"
}

variable "alb_ingress_http_from_port" {
  type = number
  default = 80
}

variable "alb_ingress_http_ip_protocol" {
  type = string
  default = "tcp"
}

variable "alb_ingress_https_cidr_ipv4" {
  type = string
  default = "0.0.0.0/0"
}

variable "alb_ingress_http_to_port" {
  type = number
  default = 80
}

variable "alb_ingress_https_from_port" {
  type = number
  default = 443
}

variable "alb_ingress_https_ip_protocol" {
  type = string
  default = "tcp"
}

variable "alb_ingress_https_to_port" {
  type = number
  default = 443
}

variable "alb_egress_cidr_ipv4" {
  type = string
  default = "0.0.0.0/0"
}

variable "alb_egress_ip_protocol" {
  type = string
  default = "-1" 
}