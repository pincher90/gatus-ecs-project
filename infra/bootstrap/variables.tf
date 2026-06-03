variable "aws_region" {
  description = "AWS region used by the GitHub Actions roles"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name used for IAM role and policy names"
  type        = string
  default     = "gatus"
}

variable "github_owner" {
  description = "GitHub organization or user that owns the repository"
  type        = string
  default     = "pincher90"
}

variable "github_repo" {
  description = "GitHub repository allowed to assume these roles"
  type        = string
  default     = "gatus-ecs-project"
}

variable "github_subjects" {
  description = "Allowed GitHub OIDC subject claims"
  type        = list(string)
  default     = ["repo:pincher90/gatus-ecs-project:ref:refs/heads/main"]
}

variable "terraform_state_bucket" {
  description = "S3 bucket used by the application Terraform backend"
  type        = string
  default     = "gatus-terraform-state-pincher90"
}

variable "terraform_state_key" {
  description = "S3 key used by the application Terraform backend"
  type        = string
  default     = "dev/terraform.tfstate"
}

variable "ecr_repository_name" {
  description = "ECR repository pushed by the Docker build workflow"
  type        = string
  default     = "gatus-repo"
}
