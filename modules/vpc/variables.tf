variable "vpc_name" {
  description = "The name tag of the existing VPC to use"
  type        = string
}

variable "alb_sg_id" {
  description = "The ID of the existing ALB security group"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "application_port" {
  description = "The port on which the application listens"
  type        = number
  default     = 80
}
