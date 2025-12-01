
data "aws_route53_zone" "existing_zone" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "app_record" {
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  name    = var.sub_domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_record_ipv6" {
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  name    = var.sub_domain_name
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = true
  }
}