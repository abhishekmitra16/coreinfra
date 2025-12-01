# =============================================================================
# ROOT OUTPUTS - These outputs expose important infrastructure endpoints
# and identifiers for external use, monitoring, and verification
# =============================================================================

# =============================================================================
# VPC & NETWORKING OUTPUTS
# =============================================================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "ecs_security_group_id" {
  description = "ID of the ECS security group"
  value       = module.vpc.ecs_security_group_id
}

output "private_hosted_zone_name" {
  description = "Name of the private hosted zone for internal service discovery"
  value       = module.vpc.private_hosted_zone_name
}

# =============================================================================
# APPLICATION LOAD BALANCER OUTPUTS
# =============================================================================

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = module.alb.alb_zone_id
}

output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.alb.alb_target_group_arn
}

output "alb_target_group_name" {
  description = "Name of the ALB target group"
  value       = module.alb.target_group_name
}

output "alb_sg_id" {
  description = "Security group ID of the ALB"
  value       = module.alb.alb_sg_id
}

# =============================================================================
# ECS CLUSTER & SERVICE OUTPUTS
# =============================================================================

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs.cluster_arn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_service_id" {
  description = "ID of the ECS service"
  value       = module.ecs.service_id
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.ecs.service_name
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = module.ecs.task_definition_arn
}

output "ecs_task_definition_family" {
  description = "Family name of the ECS task definition"
  value       = module.ecs.task_definition_family
}

output "ecs_log_group_name" {
  description = "Name of the CloudWatch log group for ECS"
  value       = module.ecs.log_group_name
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = module.ecs.task_execution_role_arn
}

# =============================================================================
# ECR REPOSITORY OUTPUTS
# =============================================================================

output "ecr_repository_url" {
  description = "URL of the ECR repository for pushing Docker images"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = module.ecr.repository_name
}

output "ecr_registry_id" {
  description = "AWS account ID (registry ID)"
  value       = module.ecr.registry_id
}

# =============================================================================
# RDS DATABASE OUTPUTS
# =============================================================================

output "rds_db_identifier" {
  description = "Identifier of the RDS instance"
  value       = module.rds.db_instance_identifier
}

output "rds_db_endpoint" {
  description = "Connection endpoint for the RDS database (do not use directly - use RDS Proxy endpoint)"
  value       = module.rds.db_instance_endpoint
  sensitive   = true
}

output "rds_db_address" {
  description = "Address/hostname of the RDS database"
  value       = module.rds.db_instance_address
  sensitive   = true
}

output "rds_db_port" {
  description = "Port of the RDS database"
  value       = module.rds.db_instance_port
}

output "rds_db_arn" {
  description = "ARN of the RDS instance"
  value       = module.rds.db_instance_arn
}

# =============================================================================
# RDS PROXY OUTPUTS
# =============================================================================

output "rds_proxy_endpoint" {
  description = "Endpoint of the RDS Proxy (use this instead of direct RDS endpoint)"
  value       = module.rds_proxy.proxy_endpoint
  sensitive   = true
}

output "rds_proxy_arn" {
  description = "ARN of the RDS Proxy"
  value       = module.rds_proxy.proxy_arn
}

output "rds_proxy_id" {
  description = "ID of the RDS Proxy"
  value       = module.rds_proxy.proxy_id
}

# =============================================================================
# SECRETS MANAGER OUTPUTS
# =============================================================================

output "secrets_manager_secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  value       = module.secrets.aws_secret_db_credentials_arn
}

# =============================================================================
# CLOUDFRONT & S3 OUTPUTS
# =============================================================================

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_arn
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution (CDN endpoint)"
  value       = module.cloudfront.cloudfront_domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "Hosted zone ID of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_zone_id
}

output "cloudfront_status" {
  description = "Current status of the CloudFront distribution"
  value       = module.cloudfront.distribution_status
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for static content"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = module.s3.bucket_regional_domain_name
}

output "s3_cloudfront_oac_id" {
  description = "ID of the CloudFront Origin Access Control for S3"
  value       = module.s3.cloudfront_oac_id
}

# =============================================================================
# RDS SECURITY GROUP OUTPUTS
# =============================================================================

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = module.rds_sg.rds_sg_id
}

output "rds_proxy_security_group_id" {
  description = "ID of the RDS Proxy security group"
  value       = module.rds_sg.rds_proxy_sg_id
}

# =============================================================================
# ROUTE 53 OUTPUTS
# =============================================================================

output "route53_private_zone_id" {
  description = "ID of the private Route 53 hosted zone"
  value       = module.route53_private.private_zone_id
}

output "route53_private_zone_name" {
  description = "Name of the private Route 53 hosted zone"
  value       = module.route53_private.private_zone_name
}

# =============================================================================
# DEPLOYMENT INFORMATION
# =============================================================================

output "deployment_region" {
  description = "AWS region where resources are deployed"
  value       = var.region
}

output "project_name" {
  description = "Project name used for resource naming"
  value       = var.project_name
}

output "environment" {
  description = "Environment name (e.g., production, staging, development)"
  value       = var.environment
}

# =============================================================================
# QUICK START REFERENCE
# =============================================================================

output "quick_reference" {
  description = "Quick reference for accessing the deployed application"
  value = {
    alb_endpoint            = "http://${module.alb.alb_dns_name}"
    cloudfront_endpoint     = "https://${module.cloudfront.cloudfront_domain_name}"
    ecr_push_command        = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${module.ecr.repository_url}"
    rds_proxy_endpoint      = module.rds_proxy.proxy_endpoint
    ecs_cluster_name        = module.ecs.cluster_name
    cloudwatch_log_group    = module.ecs.log_group_name
  }
  sensitive = true
}
