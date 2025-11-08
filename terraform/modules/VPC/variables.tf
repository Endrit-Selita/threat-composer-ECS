variable "vpc-ecs_cider_block" {
    type = string
    default = "10.10.0.0/16"
}

variable "az_state" {
    type = string
    default = "available"
}

variable "public_subnet_1_cidr_block" {
    type = string
    default = "10.10.1.0/24"
}

variable "public_subnet_1_map_public_ip_on_launch" {
    type = bool
    default = true
}

variable "eip1_domain" {
    type = string
    default = "vpc"
}

variable "public_subnet_2_cidr_block" {
    type = string
    default = "10.10.2.0/24"
}

variable "public_subnet_2_map_public_ip_on_launch" {
    type = bool
    default = true
}

variable "eip2_domain" {
    type = string
    default = "vpc"
}

variable "private_subnet_1_cidr_block" {
    type = string
    default = "10.10.3.0/24"
}

variable "private_subnet_1_map_public_ip_on_launch" {
    type = bool
    default = false
}

variable "private_subnet_2_cidr_block" {
    type = string
    default = "10.10.4.0/24"
}

variable "private_subnet_2_map_public_ip_on_launch" {
    type = bool
    default = false
}

variable "ig_rt_public_cidr_block" {
    type = string
    default = "0.0.0.0/0"
}

variable "ng_rt_ecs_1_cidr_block" {
    type = string
    default = "0.0.0.0/0"
}

variable "ng_rt_ecs_2_cidr_block" {
    type = string
    default = "0.0.0.0/0"
}