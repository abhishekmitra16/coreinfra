output "quick_reference" {
  description = "Quick reference for accessing the deployed application"
  value = {
    alb_endpoint         = "http://${module.alb.alb_dns_name}"
    cloudfront_endpoint  = "https://${module.cloudfront.cloudfront_domain_name}"
    url_endpoint          = "https://${var.sub_domain_name}.${var.domain_name}"
    ecr_push_command     = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${module.ecr.repository_url}"
    rds_proxy_endpoint   = module.rds_proxy.proxy_endpoint
    ecs_cluster_name     = module.ecs.cluster_name
    cloudwatch_log_group = module.ecs.log_group_name
  }
  sensitive = true
}
