data "aws_route53_zone" "gatus" {
  name         = var.hosted_zone_name
  private_zone = false
}