variable "domain_name" {
  description = "Public hostname for the application"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route 53 hosted zone name for the delegated subdomain"
  type        = string
}
