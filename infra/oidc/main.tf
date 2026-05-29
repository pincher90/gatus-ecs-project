data "aws_caller_identity" "current" {}

locals {
  github_oidc_provider_url = "https://token.actions.githubusercontent.com"
  repository_slug          = "${var.github_owner}/${var.github_repo}"
  ecr_repository_arn       = "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.ecr_repository_name}"
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = local.github_oidc_provider_url
  client_id_list = ["sts.amazonaws.com"]

  tags = {
    Name = "${var.project_name}-github-oidc"
  }
}

data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = var.github_subjects
    }
  }
}

resource "aws_iam_role" "github_ecr" {
  name                 = "${var.project_name}-github-ecr-role"
  description          = "GitHub Actions OIDC role for ${local.repository_slug} Docker image pushes"
  assume_role_policy   = data.aws_iam_policy_document.github_actions_trust.json
  max_session_duration = 3600

  tags = {
    Name       = "${var.project_name}-github-ecr-role"
    Repository = local.repository_slug
  }
}

data "aws_iam_policy_document" "github_ecr" {
  statement {
    sid       = "GetEcrAuthorizationToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "PushImageToProjectRepository"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [local.ecr_repository_arn]
  }
}

resource "aws_iam_policy" "github_ecr" {
  name        = "${var.project_name}-github-ecr-policy"
  description = "Least-privilege ECR push permissions for ${local.repository_slug}"
  policy      = data.aws_iam_policy_document.github_ecr.json
}

resource "aws_iam_role_policy_attachment" "github_ecr" {
  role       = aws_iam_role.github_ecr.name
  policy_arn = aws_iam_policy.github_ecr.arn
}

resource "aws_iam_role" "github_terraform" {
  name                 = "${var.project_name}-github-terraform-role"
  description          = "GitHub Actions OIDC role for ${local.repository_slug} Terraform deploys"
  assume_role_policy   = data.aws_iam_policy_document.github_actions_trust.json
  max_session_duration = 3600

  tags = {
    Name       = "${var.project_name}-github-terraform-role"
    Repository = local.repository_slug
  }
}

data "aws_iam_policy_document" "github_terraform" {
  #checkov:skip=CKV_AWS_107:Terraform deploy role does not grant access to secret values; broad read/list actions are for provider state refresh.
  #checkov:skip=CKV_AWS_109:IAM permissions are constrained to project role names and the ECS task execution managed policy.
  #checkov:skip=CKV_AWS_111:Terraform requires write permissions to create and update the project infrastructure resources.
  #checkov:skip=CKV_AWS_356:Some Terraform-managed AWS create and describe APIs do not support resource-level constraints.
  statement {
    sid    = "ManageProjectNetworkAndCompute"
    effect = "Allow"
    actions = [
      "ec2:*",
      "ecs:*",
      "elasticloadbalancing:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ManageProjectEcrRepository"
    effect = "Allow"
    actions = [
      "ecr:CreateRepository",
      "ecr:DeleteRepository",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetLifecyclePolicy",
      "ecr:GetRepositoryPolicy",
      "ecr:ListTagsForResource",
      "ecr:PutImageScanningConfiguration",
      "ecr:PutImageTagMutability",
      "ecr:SetRepositoryPolicy",
      "ecr:TagResource",
      "ecr:UntagResource"
    ]
    resources = [local.ecr_repository_arn]
  }

  statement {
    sid    = "CreateProjectEcrRepository"
    effect = "Allow"
    actions = [
      "ecr:CreateRepository",
      "ecr:DescribeRepositories"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ManageProjectIamRoles"
    effect = "Allow"
    actions = [
      "iam:AttachRolePolicy",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.project_name}-ecs-task-execution-role",
      "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    ]
  }

  statement {
    sid       = "ManageProjectLogs"
    effect    = "Allow"
    actions   = ["logs:*"]
    resources = ["*"]
  }

  statement {
    sid    = "ReadAcmCertificate"
    effect = "Allow"
    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AccessTerraformState"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::${var.terraform_state_bucket}/${var.terraform_state_key}",
      "arn:aws:s3:::${var.terraform_state_bucket}/${var.terraform_state_key}.tflock"
    ]
  }

  statement {
    sid       = "ListTerraformStateBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.terraform_state_bucket}"]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values = [
        var.terraform_state_key,
        "${var.terraform_state_key}.tflock"
      ]
    }
  }
}

resource "aws_iam_policy" "github_terraform" {
  #checkov:skip=CKV_AWS_290:Terraform needs write permissions across project resource types to create, update, and destroy managed infrastructure.
  #checkov:skip=CKV_AWS_355:Several AWS APIs used by Terraform require wildcard resources for create and describe actions.
  name        = "${var.project_name}-github-terraform-policy"
  description = "Terraform deployment permissions for ${local.repository_slug}"
  policy      = data.aws_iam_policy_document.github_terraform.json
}

resource "aws_iam_role_policy_attachment" "github_terraform" {
  role       = aws_iam_role.github_terraform.name
  policy_arn = aws_iam_policy.github_terraform.arn
}
