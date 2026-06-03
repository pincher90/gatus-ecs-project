variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  type        = list(string)
}

variable "image_tag" {
  description = "Docker image tag to deploy to ECS"
  type        = string
}

variable "ecs_cpu" {
  description = "CPU units for the ECS Fargate task"
  type        = number
}

variable "ecs_memory" {
  description = "Memory in MiB for the ECS Fargate task"
  type        = number
}

variable "ecs_desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
}

variable "domain_name" {
  description = "Public hostname for the gatus service"
  type        = string
}

variable "hosted_zone_name" {
  description = "Route 53 hosted zone name for the delegated subdomain"
  type        = string
}
