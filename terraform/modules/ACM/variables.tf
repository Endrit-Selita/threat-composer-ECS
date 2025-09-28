variable "domain_name" {
  description = "Domain name for ACM certificate"
  type        = string
  default     = "tm.tahirbajramselita.co.uk"
}

variable "validation_method" {
  description = "validation menthod of the domain name"
  type        = string
  default     = "DNS"
}

variable "ttl" {
  description = "How long (in seconds) DNS resolvers can cache a record before querying Route 53 for fresh data"
  type        = number
  default     = 60
}

variable "zone_id" {
    description = "the route 53 zone id"
    type = string
    default = "aws_route53_zone.r53_zone.id"
}