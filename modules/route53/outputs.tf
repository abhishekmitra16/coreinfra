# Route53 Module Outputs

output "route53_zone_id" {
  description = "The ID of the Route53 hosted zone."
  value       = data.aws_route53_zone.existing_zone.zone_id
}