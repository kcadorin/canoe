resource "aws_route53_record" "ecs_service" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${local.module_vars.dns_name}.${local.module_vars.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_alb.alb.dns_name}"]
}

# Create hosted Zones
resource "aws_route53_zone" "main" {
  name = local.module_vars.domain
}

# DNS Validation
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}
