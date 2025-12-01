# ALB Module Outputs

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.app.arn
}

output "alb_target_group_arn" {
  description = "ARN of the ALB target group (alias for target_group_arn)"
  value       = aws_lb_target_group.app.arn
}

output "target_group_name" {
  description = "Name of the ALB target group"
  value       = aws_lb_target_group.app.name
}

output "alb_dns_name" {
  description = "DNS name of the existing ALB"
  value       = var.alb_exists ? data.aws_lb.existing_alb[0].dns_name : aws_lb.main_alb[0].dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the existing ALB"
  value       = var.alb_exists ? data.aws_lb.existing_alb[0].zone_id : aws_lb.main_alb[0].zone_id
}

output "alb_sg_id" {
  description = "Security group ID of the existing ALB"
  value       = var.alb_exists ? data.aws_security_group.alb_sg[0].id : aws_security_group.main_alb_sg[0].id
}

output "listener_arn" {
  description = "ARN of the first ALB listener"
  value       = var.alb_exists ? data.aws_lb_listener.alb_listener[0].arn : aws_lb_listener.main_listener[0].arn
}

# output "acm_certificate_arn" {
#   description = "ARN of the ACM certificate for the domain"
#   value       = var.use_existing_certificate ? data.aws_acm_certificate.existing[0].arn : aws_acm_certificate.main[0].arn
# }