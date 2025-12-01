variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string
}


variable "private_hosted_zone_name" {
  description = "The name of the private hosted zone."
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