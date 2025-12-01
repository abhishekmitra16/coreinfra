variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs."
  type        = number
  default     = 30
}

variable "ecs_cpu" {
  description = "The amount of CPU to allocate to the ECS task."
  type        = number
  default     = 256
}

variable "ecs_memory" {
  description = "The amount of memory to allocate to the ECS task."
  type        = number
  default     = 512
}

variable "container_name" {
  description = "The name of the container."
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

variable "repository_url" {
  description = "The URL of the ECR repository."
  type        = string
}

variable "image_tag" {
  description = "The tag of the image to use from the ECR repository."
  type        = string
  default     = "latest"
}

variable "application_port" {
  description = "The port on which the application listens."
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "The desired number of ECS tasks to run."
  type        = number
  default     = 1
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ECS service."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "The security group ID for the ECS service."
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the target group to associate with the ECS service."
  type        = string
}

variable "existing_cluster_name" {
  description = "The name of the existing ECS cluster to use."
  type        = string
}

variable "cluster_exists" {
  description = "Flag to indicate if the ECS cluster already exists."
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
  default     = ""
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ECS service."
  type        = list(string)
}