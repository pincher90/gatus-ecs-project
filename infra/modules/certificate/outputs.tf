output "certificate_arn" {
  description = "Validated ACM certificate ARN for the ALB HTTPS listener"
  value       = aws_acm_certificate_validation.alb.certificate_arn
}

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID used for certificate validation"
  value       = data.aws_route53_zone.gatus.zone_id
}
