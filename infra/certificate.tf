module "certificate" {
  source = "./modules/certificate"

  domain_name      = var.domain_name
  hosted_zone_name = var.hosted_zone_name
}
