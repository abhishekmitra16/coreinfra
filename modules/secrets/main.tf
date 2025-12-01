# secrets.tf
resource "random_password" "db_master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project_name}/database-credentials"
  description = "Database master credentials for ${var.project_name}"
  

  tags = {
    Name        = "${var.project_name}-db-credentials"
    Project     = var.project_name
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "dbadmin"
    password = random_password.db_master_password.result
    engine   = "mysql"
    port     = var.database_port
    dbname   = var.database_name
  })
}