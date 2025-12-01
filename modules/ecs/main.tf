resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = var.log_retention_days
}


# resource "aws_ecs_cluster" "main" {
#   name = "${var.project_name}-ecs-cluster"

# }

data "aws_ecs_cluster" "existing_cluster" {

  count = var.cluster_exists ? 1 : 0

  cluster_name = var.cluster_name
}

resource "aws_ecs_cluster" "main" {

  count = var.cluster_exists ? 0 : 1
  name  = "${var.project_name}-ecs-cluster"

}


resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.container_name}"
      image     = var.initial_image_exists ? "${var.repository_url}:${var.image_tag}" : var.private_sample_image
      cpu       = var.ecs_cpu
      memory    = var.ecs_memory
      essential = true
      portMappings = [
        {
          containerPort = var.application_port
          hostPort      = var.application_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = var.project_name
        }
      }
    }
  ])
}


resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-ecs-service"
  cluster         = var.cluster_exists ? data.aws_ecs_cluster.existing_cluster[0].id : aws_ecs_cluster.main[0].id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.application_port
  }

  depends_on = [aws_iam_role.ecs_task_execution_role, data.aws_ecs_cluster.existing_cluster]

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  wait_for_steady_state = true

  tags = {
    Name = "${var.project_name}-ecs-service"
  }

}