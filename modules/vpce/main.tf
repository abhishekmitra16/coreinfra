
# security_groups.tf
resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.project_name}-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from private subnets"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-vpc-endpoints-sg"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids

  tags = {
    Name = "${var.project_name}-s3-vpce"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-ecr-api-vpce"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-ecr-dkr-vpce"
  }
}


resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true
  tags = {
    Name = "${var.project_name}-cloudwatch-logs-vpce"
  }
}

resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true
  tags = {
    Name = "${var.project_name}-secrets-manager-vpce"
  }
}


resource "aws_vpc_endpoint" "ecs_telemetry" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecs-telemetry"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true
  tags = {
    Name = "${var.project_name}-ecs-telemetry-vpce"
  }
}

