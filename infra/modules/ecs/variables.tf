variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN for ECS service"
  type        = string
}

variable "container_image" {
  description = "Container image for the ECS task"
  type        = string
}

variable "container_port" {
  description = "Container port exposed by the application"
  type        = number
  default     = 8080
}

variable "task_cpu" {
  description = "CPU units for the ECS Fargate task"
  type        = number
}

variable "task_memory" {
  description = "Memory in MiB for the ECS Fargate task"
  type        = number
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
}

variable "aws_region" {
  type = string
}
