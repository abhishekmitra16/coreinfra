variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string
}

variable "s3_origin_id" {
  description = "The origin ID for the S3 bucket"
  type        = string
}

variable "s3_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  type        = string
}

variable "backend_alb_dns_name" {
  description = "The DNS name of the backend ALB"
  type        = string

}

variable "cloudfront_oac_id" {
  description = "The CloudFront Origin Access Control ID for S3"
  type        = string

}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for CloudFront"
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
