############### Create Route 53 ###############
data "aws_route53_zone" "r53_zone" {
  name = var.aws_route53_zone_name
}

resource "aws_route53_record" "r53_record" {
  zone_id = data.aws_route53_zone.r53_zone.id
  name    = var.aws_route53_record_name
  type    = var.aws_route53_record_type

  alias {
    name                   = var.alias_target_dns_name # add to root module: module.alb.alb_dns_name
    zone_id                = var.alias_target_zone_id  # add to root module: module.alb.alb_zone_id
    evaluate_target_health = var.aws_route53_alias_evaluate_target_health
  }
}