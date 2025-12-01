resource "aws_ecr_repository" "main" {
  name                 = "${var.project_name}-repository"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-ecr"
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = <<EOF
    {
    "rules": [
        {
        "rulePriority": 1,
        "description": "Expire untagged images more than allowed count",
        "selection": {
            "tagStatus": "untagged",
            "countType": "imageCountMoreThan",
            "countNumber": 10
        },
        "action": {
            "type": "expire"
        }
        }
    ]
    }
    EOF
}