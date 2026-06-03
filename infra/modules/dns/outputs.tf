output "record_fqdn" {
  description = "Fully qualified DNS record created for the application"
  value       = aws_route53_record.gatus.fqdn
}

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID used for the application alias"
  value       = data.aws_route53_zone.gatus.zone_id
}
