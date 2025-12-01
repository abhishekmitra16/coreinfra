# VPC Module Outputs

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main_vpc.cidr_block
}

output "ecs_security_group_id" {
  description = "ID of the ECS security group"
  value       = aws_security_group.ecs_sg.id
}

output "ecs_security_group_arn" {
  description = "ARN of the ECS security group"
  value       = aws_security_group.ecs_sg.arn
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
    aws_subnet.public_subnet_3.id,
    aws_subnet.public_subnet_4.id
  ]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
    aws_subnet.private_subnet_3.id
  ]
}

output "private_hosted_zone_name" {
  description = "Name of the private hosted zone"
  value       = aws_route53_zone.private.name
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value = [
    aws_route_table.private.id
  ]
}