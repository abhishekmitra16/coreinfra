# RDS Proxy Module Outputs

output "proxy_id" {
  description = "ID of the RDS Proxy"
  value       = aws_db_proxy.main.id
}

output "proxy_arn" {
  description = "ARN of the RDS Proxy"
  value       = aws_db_proxy.main.arn
}

output "proxy_endpoint" {
  description = "Endpoint of the RDS Proxy"
  value       = aws_db_proxy.main.endpoint
}
