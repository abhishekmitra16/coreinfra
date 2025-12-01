variable "domain_name" {
  description = "The domain name for the ALB."
  type        = string
}

variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string
}

variable "sub_domain_name" {
  description = "The subdomain name for the ALB."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the ALB and target group will be created."
  type        = string

}

variable "use_existing_certificate" {
  description = "Flag to indicate if an existing ACM certificate should be used."
  type        = bool
  default     = false
}

variable "alb_exists" {
  description = "Flag to indicate if the ALB already exists."
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "The Route 53 Hosted Zone ID for the domain."
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB."
  type        = list(string)
}

variable "alb_name" {
  description = "The name of the existing ALB."
  type        = string
}

variable "alb_listener_port" {
  description = "The port of the ALB listener to attach the rule to."
  type        = number
  default     = 443

}

variable "health_check_path" {
  description = "The health check path for the target group."
  type        = string
  default     = "/"
}

variable "application_port" {
  description = "The port on which the application listens."
  type        = number
  default     = 80
}


