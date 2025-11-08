variable "aws_ecr_repository_name" {
    type = string
    default = "ecr_app"
}

variable "aws_ecr_repository_image_tag_mutability" {
    type = string
    default = "MUTABLE"
}

variable "ecr_scan_on_push" {
    type = bool
    default = true
}