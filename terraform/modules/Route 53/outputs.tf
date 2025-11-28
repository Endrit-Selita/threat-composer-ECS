output "aws_route53_zone_name" {
  value = aws_route53_zone.r53_zone.name
}

output "aws_route53_record_name" {
  value = aws_route53_record.r53_record.name
}

output "aws_route53_fqdn" {
  value = aws_route53_record.r53_record.fqdn
}

output "zone_id" {
  value = aws_route53_zone.r53_zone.id
}
