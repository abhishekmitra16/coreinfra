# route53.tf
resource "aws_route53_zone" "private" {
  name = "internal.${var.project_name}.local"

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name        = "${var.project_name}-private-zone"
    Project = var.project_name
  }
}

resource "aws_route53_record" "database" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.${aws_route53_zone.private.name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.rds_proxy_endpoint]
}

# Optional: Additional records for different services
resource "aws_route53_record" "database_readonly" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db-ro.${aws_route53_zone.private.name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.rds_proxy_endpoint] # Same proxy, but you could create read-only endpoints
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "api.${aws_route53_zone.private.name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name # Pass ALB DNS name from ALB module
    zone_id                = var.alb_zone_id  # Pass ALB zone ID from ALB module
    evaluate_target_health = true
  }
}