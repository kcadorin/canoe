resource "aws_route53_record" "ecs_service" {
  count   = local.module_vars.dns_name == "" ? 0 : 1
  zone_id = data.aws_route53_zone.domain[0].zone_id
  name    = "${local.module_vars.dns_name}.${local.module_vars.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_alb.alb.dns_name}"]
}

data "aws_route53_zone" "domain" {
  count = local.module_vars.domain == "" ? 0 : 1
  name  = local.module_vars.domain
}
