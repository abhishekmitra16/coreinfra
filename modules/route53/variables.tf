variable "domain_name" {
  description = "The domain name for the application."
  type        = string

}
variable "sub_domain_name" {
  description = "The subdomain name for the application."
  type        = string

}

variable "cloudfront_domain_name" {
  description = "The DNS name of the CloudFront distribution."
  type        = string

}

variable "cloudfront_zone_id" {
  description = "The hosted zone ID of the CloudFront distribution."
  type        = string

}
