data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "managed_caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all_viewer" {
  name = "Managed-AllViewer"
}

resource "aws_cloudfront_distribution" "main" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "CloudFront Distribution for ${var.project_name}"

  aliases = ["${var.sub_domain_name}.${var.domain_name}"]

  #   origin {
  #     domain_name = var.domain_name
  #     origin_id   = "origin-${var.domain_name}"

  #     custom_origin_config {
  #       http_port              = 80
  #       https_port             = 443
  #       origin_protocol_policy = "https-only"
  #       origin_ssl_protocols   = ["TLSv1.2"]
  #     }
  #   }

  origin {
    domain_name              = var.s3_regional_domain_name
    origin_access_control_id = var.cloudfront_oac_id
    origin_id                = var.s3_origin_id
  }

  origin {
    domain_name = var.backend_alb_dns_name
    origin_id   = "backend-alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_optimized.id

    target_origin_id       = var.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true



  }

  # SPA routing - redirect 404/403 to index.html
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  ordered_cache_behavior {

    cache_policy_id = data.aws_cloudfront_cache_policy.managed_caching_disabled.id

    path_pattern             = "/api/*"
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "backend-alb-origin"
    compress                 = true
    viewer_protocol_policy   = "redirect-to-https"
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer.id


  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }


  lifecycle {
    ignore_changes = [
      default_cache_behavior,
      origin,
      viewer_certificate,
      aliases
    ]
  }

  tags = {
    Name = "${var.project_name}-cloudfront"
  }

}
