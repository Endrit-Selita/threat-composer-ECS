############### ACM ###############

resource "aws_acm_certificate" "acm_cert" {
  domain_name       = var.domain_name
  validation_method = var.validation_method
}

resource "aws_route53_record" "r53_cname" {
  for_each = {
    for dvo in aws_acm_certificate.acm_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.ttl
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "acm_validation" {
  certificate_arn         = "${aws_acm_certificate.acm_cert.arn}"
  validation_record_fqdns = [for record in aws_route53_record.r53_cname : record.fqdn]
}