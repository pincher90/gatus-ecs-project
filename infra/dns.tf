data "aws_route53_zone" "gatus" {
  name         = var.hosted_zone_name
  private_zone = false
}
resource "aws_route53_record" "gatus" {
  zone_id = data.aws_route53_zone.gatus.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}