output "github_ecr_role_arn" {
  description = "GitHub Actions role ARN for Docker image builds and ECR pushes"
  value       = aws_iam_role.github_ecr.arn
}

output "github_terraform_role_arn" {
  description = "GitHub Actions role ARN for Terraform deploys"
  value       = aws_iam_role.github_terraform.arn
}
