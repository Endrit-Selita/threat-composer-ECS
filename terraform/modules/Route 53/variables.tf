variable "aws_route53_zone_name" {
  type = string
  default = "tahirbajramselita.co.uk"
}

variable "aws_route53_record_name" {
  type = string
  default = "tm.tahirbajramselita.co.uk"
}

variable "aws_route53_record_type" {
  type = string
  default = "A"
}

variable "aws_route53_alias_evaluate_target_health" {
  type = bool
  default = true
}