module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr
}

module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  certificate_arn       = module.certificate.certificate_arn
}

module "ecs" {
  source = "./modules/ecs"

  project_name          = var.project_name
  aws_region            = var.aws_region
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.security.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn
  container_image       = "${module.ecr.repository_url}:${var.image_tag}"
  container_port        = 8080
  task_cpu              = var.ecs_cpu
  task_memory           = var.ecs_memory
  desired_count         = var.ecs_desired_count
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}
