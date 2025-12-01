
# # ACM CERTIFICATE
# # IF CERTIFICATE EXISTS, USE IT; ELSE CREATE A NEW ONE

data "aws_acm_certificate" "existing" {

  count =  var.use_existing_certificate ? 1 : 0

  domain   = var.domain_name
  statuses = ["ISSUED"]
}

resource "aws_acm_certificate" "main" {

  count =  var.use_existing_certificate ? 0 : 1

  domain_name = var.domain_name
  # Enable wildcard certificate
  subject_alternative_names = ["*.${var.domain_name}"]

  validation_method = "DNS"

  tags = {
    Name = "${var.project_name}-acm-certificate"
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = var.use_existing_certificate ? {} : {
    for dvo in aws_acm_certificate.main[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = var.route53_zone_id
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  count =  var.use_existing_certificate ? 0 : 1

  certificate_arn         = aws_acm_certificate.main[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}



# ALB 
# USE IF EXISTS OR CREATE NEW


data "aws_lb" "existing_alb" {
  count =  var.alb_exists ? 1 : 0
  name  = var.alb_name
}

resource "aws_lb" "main_alb" {
  count =  var.alb_exists ? 0 : 1

  name               = "${var.project_name}-alb"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.main_alb_sg[0].id]
  internal           = false
  load_balancer_type = "application"

}


# ALB LISTENERS 

# HTTPS LISTENER
data "aws_lb_listener" "alb_listener" {

  count =  var.alb_exists ? 1 : 0

  load_balancer_arn = data.aws_lb.existing_alb[0].arn
  port              = var.alb_listener_port
}

resource "aws_lb_listener" "main_listener" {
  count =  var.alb_exists ? 0 : 1

  load_balancer_arn = aws_lb.main_alb[0].arn
  port              = var.alb_listener_port
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.use_existing_certificate ? data.aws_acm_certificate.existing[0].arn : aws_acm_certificate.main[0].arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "This might not be the page you are looking for..."
      status_code  = "404"
    }
  }
}


# HTTP LISTENER
data "aws_lb_listener" "http_listener" {
  count =  var.alb_exists ? 1 : 0

  load_balancer_arn = data.aws_lb.existing_alb[0].arn
  port              = 80
}

resource "aws_lb_listener" "http_listener" {
  count =  var.alb_exists ? 0 : 1

  load_balancer_arn = aws_lb.main_alb[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


# ALB SECURITY GROUP
data "aws_security_group" "alb_sg" {

  count =  var.alb_exists ? 1 : 0
  id    = tolist(data.aws_lb.existing_alb[0].security_groups)[0]
}

resource "aws_security_group" "main_alb_sg" {
  count =  var.alb_exists ? 0 : 1
  name        = "${var.project_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# ALB TARGET GROUP AND LISTENER RULES

resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-tg"
  port        = var.application_port
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  deregistration_delay = 10

  health_check {
    enabled             = true
    path                = var.health_check_path
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

resource "aws_lb_listener_rule" "app_rule" {
  listener_arn = var.alb_exists ? data.aws_lb_listener.alb_listener[0].arn : aws_lb_listener.main_listener[0].arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["${var.sub_domain_name}.${var.domain_name}"]
    }
  }
}