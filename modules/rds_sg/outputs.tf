# RDS Security Group Module Outputs

output "rds_sg_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}

output "rds_proxy_sg_id" {
  description = "ID of the RDS Proxy security group"
  value       = aws_security_group.rds_proxy_sg.id
}
