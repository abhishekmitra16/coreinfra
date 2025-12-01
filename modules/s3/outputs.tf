# S3 Module Outputs

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.react_frontend_bucket.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.react_frontend_bucket.arn
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.react_frontend_bucket.bucket_regional_domain_name
}

output "s3_regional_domain_name" {
  description = "Regional domain name of the S3 bucket (legacy output name)"
  value       = aws_s3_bucket.react_frontend_bucket.bucket_regional_domain_name
}

output "cloudfront_oac_id" {
  description = "ID of the CloudFront Origin Access Control"
  value       = aws_cloudfront_origin_access_control.s3_oac.id
}

output "cloudfront_oac_arn" {
  description = "ARN of the CloudFront Origin Access Control"
  value       = aws_cloudfront_origin_access_control.s3_oac.id
}

output "project_name" {
  description = "Project name used for resource naming"
  value       = var.project_name
}

output "s3_origin_id" {
  description = "Origin ID for the S3 bucket in CloudFront"
  value       = "s3-${aws_s3_bucket.react_frontend_bucket.id}"
}