############### Create Route 53 ###############
resource "aws_route53_zone" "r53_zone" {
  name = "tahirbajramselita.co.uk"
}

resource "aws_route53_record" "r53_record" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = "tm.tahirbajramselita.co.uk"
  type    = "A"

  alias {
    name                   = aws_lb.alb-ecs.dns_name
    zone_id                = aws_lb.alb-ecs.zone_id
    evaluate_target_health = true
  }
}