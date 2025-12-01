# ECS Module Outputs

output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = var.cluster_exists ? data.aws_ecs_cluster.existing_cluster[0].id : aws_ecs_cluster.main[0].id
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = var.cluster_exists ? data.aws_ecs_cluster.existing_cluster[0].arn : aws_ecs_cluster.main[0].arn
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = var.cluster_exists ? data.aws_ecs_cluster.existing_cluster[0].cluster_name : aws_ecs_cluster.main[0].name
}

output "service_id" {
  description = "ID of the ECS service"
  value       = aws_ecs_service.main.id
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.main.name
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.main.arn
}

output "task_definition_family" {
  description = "Family name of the task definition"
  value       = aws_ecs_task_definition.main.family
}

output "task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_logs.name
}

output "ecs_container_name" {
  description = "Name of the ECS container"
  value       = var.container_name
}