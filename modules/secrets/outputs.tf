output "aws_secret_db_credentials_arn" {
  description = "The ARN of the Secrets Manager secret for database credentials."
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "db_master_password" {
  description = "The master password for the database."
  value       = random_password.db_master_password.result
  sensitive   = true
}

output "db_username" {
  description = "The master username for the database."
  value       = "dbadmin"
}

output "secret_version_id" {
  description = "The version ID of the secret."
  value       = aws_secretsmanager_secret_version.db_credentials.id
}