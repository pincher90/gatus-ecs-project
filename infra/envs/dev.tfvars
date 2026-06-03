aws_region = "eu-west-2"

project_name = "gatus"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

availability_zones = [
  "eu-west-2a",
  "eu-west-2b"
]

ecs_cpu           = 256
ecs_memory        = 512
ecs_desired_count = 1

domain_name      = "gatus.appjojocloud.com"
hosted_zone_name = "gatus.appjojocloud.com."
