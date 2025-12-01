variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string

}

variable "db_instance_identifier" {
  description = "The identifier for the RDS DB instance."
  type        = string
}

variable "database_name" {
  description = "The name of the database."
  type        = string
}

variable "database_port" {
  description = "The port on which the database listens."
  type        = number
  default     = 3306
}

variable "vpc_id" {
  description = "The ID of the VPC where RDS and RDS Proxy will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS and RDS Proxy."
  type        = list(string)
}

variable "db_username" {
  description = "The master username for the database."
  type        = string
}

variable "db_password" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
}

variable "secret_version_id" {
  description = "The version ID of the secret (for dependency)."
  type        = string
}

variable "rds_security_group_id" {
  description = "The ID of the RDS security group."
  type        = string
}