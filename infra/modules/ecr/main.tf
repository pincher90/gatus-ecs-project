resource "aws_ecr_repository" "main" {
  name                 = "${var.project_name}-repo"
  force_delete         = true
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = {
    Name = "${var.project_name}-repo"
  }
}
