variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string
}


variable "private_hosted_zone_name" {
  description = "The name of the private hosted zone."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the private hosted zone will be created."
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the existing ALB."
  type        = string
}

variable "alb_zone_id" {
  description = "The zone ID of the existing ALB."
  type        = string
}

variable "rds_proxy_endpoint" {
  description = "The endpoint of the RDS Proxy."
  type        = string
}