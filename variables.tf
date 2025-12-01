# ==============================================================================
# GLOBAL / COMMON VARIABLES
# ==============================================================================

variable "region" {
  description = "The region where resources will be created"
  type        = string
}

variable "profile" {
  description = "The AWS CLI profile to use"
  type        = string
}

variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
}

variable "domain_name" {
  description = "The domain name for the application."
  type        = string
}

variable "sub_domain_name" {
  description = "The subdomain name for the application."
  type        = string
}

variable "application_port" {
  description = "The port on which the application listens."
  type        = number
  default     = 80
}

# ==============================================================================
# VPC MODULE VARIABLES
# ==============================================================================

variable "vpc_name" {
  description = "The name of the VPC where resources will be deployed."
  type        = string
}

# ==============================================================================
# ALB MODULE VARIABLES
# ==============================================================================

variable "alb_name" {
  description = "The name of the existing ALB."
  type        = string
}

variable "alb_exists" {
  description = "Flag to indicate if the ALB already exists."
  type        = bool
  default     = false
}

variable "use_existing_certificate" {
  description = "Flag to indicate if an existing ACM certificate should be used."
  type        = bool
  default     = false
}

variable "health_check_path" {
  description = "The health check path for the target group."
  type        = string
  default     = "/"
}

# ==============================================================================
# ECS MODULE VARIABLES
# ==============================================================================

variable "cluster_exists" {
  description = "Flag to indicate if the ECS cluster already exists."
  type        = bool
  default     = false
}

variable "existing_cluster_name" {
  description = "The name of the existing ECS cluster, if applicable."
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}
variable "initial_image_exists" {
  description = "Flag to indicate if an initial image exists in the repository."
  type        = bool
  default     = false
}
variable "private_sample_image" {
  description = "Private Sample Image if real image does not exist yet"
  type        = string
}

variable "image_tag" {
  description = "The tag of the image to use from the ECR repository."
  type        = string
  default     = "latest"
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs."
  type        = number
  default     = 30
}

variable "ecs_cpu" {
  description = "The amount of CPU to allocate to the ECS task."
  type        = string
  default     = "256"
}

variable "ecs_memory" {
  description = "The amount of memory to allocate to the ECS task."
  type        = string
  default     = "512"
}

variable "container_name" {
  description = "The name of the container."
  type        = string
}

variable "desired_count" {
  description = "The desired number of ECS tasks to run."
  type        = number
  default     = 1
}


# ==============================================================================
# RDS MODULE VARIABLES
# ==============================================================================

variable "db_instance_identifier" {
  description = "The identifier for the RDS DB instance."
  type        = string

}

variable "database_name" {
  description = "The name of the database."
  type        = string
}

variable "database_port" {
  description = "The port for the database."
  type        = number
  default     = 3306
}

# ==============================================================================
# RDS PROXY MODULE VARIABLES
# ==============================================================================

variable "rds_proxy_name" {
  description = "The name of the RDS Proxy."
  type        = string
  default     = "rds-proxy"
}

# ==============================================================================
# RDS SECURITY GROUP MODULE VARIABLES
# ==============================================================================

variable "rds_sg_name" {
  description = "The name of the RDS security group."
  type        = string
  default     = "rds-sg"
}

