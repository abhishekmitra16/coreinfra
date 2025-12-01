variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string
}

variable "region" {
  description = "The AWS region where VPC endpoints will be created."
  type        = string
}


variable "vpc_id" {
  description = "The ID of the VPC where VPC endpoints will be created."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the VPC endpoints."
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "List of private route table IDs for the Gateway VPC endpoints."
  type        = list(string)
}
