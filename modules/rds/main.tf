# rds.tf
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier            = var.db_instance_identifier
  instance_class        = "db.t3.small"
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  engine                = "mysql"
  engine_version        = "8.4"
  db_name               = var.database_name
  username              = var.db_username
  password              = var.db_password
  port                  = var.database_port

  # Multi-AZ for high availability
  multi_az               = true
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]

  # Backup and maintenance
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name        = var.db_instance_identifier
    Project     = var.project_name
  }

  lifecycle {
    ignore_changes = [password]
  }
}