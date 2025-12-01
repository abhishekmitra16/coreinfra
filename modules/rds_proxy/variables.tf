variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string

}



variable "aws_secret_db_credentials_arn" {
  description = "The ARN of the AWS Secrets Manager secret containing database credentials."
  type        = string

}

variable "aws_db_instance_identifier" {
  description = "The identifier of the RDS DB instance to connect the proxy to."
  type        = string

}


variable "rds_proxy_name" {
  description = "The name of the RDS Proxy."
  type        = string

}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS Proxy."
  type        = list(string)

}

variable "vpc_id" {
  description = "The ID of the VPC where RDS Proxy will be deployed."
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

variable "rds_proxy_security_group_id" {
  description = "The ID of the RDS Proxy security group."
  type        = string
}
