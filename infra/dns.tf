module "dns" {
  source = "./modules/dns"

  domain_name      = var.domain_name
  hosted_zone_name = var.hosted_zone_name
  alb_dns_name     = module.alb.alb_dns_name
  alb_zone_id      = module.alb.alb_zone_id
}
