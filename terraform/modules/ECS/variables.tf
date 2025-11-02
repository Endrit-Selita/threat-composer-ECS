variable "ecs_cluster_name" {
  type = string
  default = "ecs_cluster"
}

variable "ecs_logging" {
  type = string
  default = "OVERRIDE"
}

variable "cloud_watch_encryption" {
  type = bool
  default = true
}

variable "cloud_watch_name" {
  type = string
  default = "ecs_cloudwatch"
}

variable "deletion_window" {
  type = number
  default = 7
}

variable "iam_policy_action" {
  type = string
  default = "sts:AssumeRole"
}

variable "principals_type" {
  type = string
  default = "Service"
}

variable "principals_identifiers" {
  type = string
  default = "ecs-tasks.amazonaws.com"
}

variable "ecs_iam_role_name" {
  type = string
  default = "instance_role"
}

variable "ecs_iam_role_assume_role_policy" {
  type = string
  default = data.aws_iam_policy_document.ecs_iam_pd.json
}

variable "ecs_exec_attach_policy_arn" {
  type = string
  default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

variable "ecs_service_family" {
  type = string
  default = "service"
}

variable "ecs_service_requires_compatibilities" {
  type = string
  default = "FARGATE"
}

variable "ecs_service_network_mode" {
  type = string
  default = "awsvpc"
}

variable "ecs_service_cpu" {
  type = number
  default = 1024
}

variable "ecs_service_memory" {
  type = number
  default = 2048
}

variable "con_def_name" {
  type = string
  default = "tcdf"
}

variable "con_def_cpu" {
  type = number
  default = 10
}

variable "ecs_service_name" {
  type = string
  default = "ecs_service"
}

variable "ecs_service_launch_type" {
  type = string
  default = "FARGATE"
}

variable "ecs_service_platform_version" {
  type = string
  default = "LATEST"
}

variable "ecs_service_desired_count" {
  type = number
  default = 2
}

variable "ecs_load_balancer_container_name" {
  type = string
  default = "tcdf"
}

variable "ecs_load_balancer_container_port" {
  type = number
  default = 80
}

variable "ecs_network_configuration_apip" {
  type = bool
  default = false
}

variable "ecs_network_configuration_subnets" {
  type = list(string)
  default = [aws_subnet.private1.id, aws_subnet.private2.id]
}