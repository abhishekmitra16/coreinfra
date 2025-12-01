variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string

}


variable "rds_sg_name" {
  description = "The name of the RDS Security Group."
  type        = string

}

variable "vpc_id" {
  description = "The ID of the VPC where RDS Security Group will be created."
  type        = string
}

variable "database_port" {
  description = "The port on which the database listens."
  type        = number
  default     = 3306

}

variable "ecs_security_group_id" {
  description = "The security group ID of the ECS tasks that will access the RDS Proxy."
  type        = string
}