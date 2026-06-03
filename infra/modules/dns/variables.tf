variable "domain_name" {
  description = "Public hostname for the application"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route 53 hosted zone name for the delegated subdomain"
  type        = string
}

variable "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  type        = string
}

variable "alb_zone_id" {
  description = "Route 53 zone ID for the Application Load Balancer"
  type        = string
}
