locals {
  common_tags = {
    Project = var.project
    Env =var.env
    Managed = "terraform"
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
  ]

  tags = local.common_tags
}

resource "aws_iam_role" "gha_terraform_dev" {
  name = "gha-terraform-dev"
  assume_role_policy = data.aws_iam_policy_document.gha_trust.json
  tags = local.common_tags
}

data "aws_iam_policy_document" "gha_trust" {
  statement {
    sid = "GitHubOIDCTrust"
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = ["sts.amazonaws.com"]
    }

    condition {
      test = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:{var.var.github_org}/${var.var.github_repo}:pull_request",
        "repo:{var.var.github_org}/${var.var.github_repo}:refs/heads/main",
      ]
    }
  }
}

data "aws_iam_policy_document" "gha_permissions" {
  statement {
    sid = "TfBackend"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${var.tfstate_bucket}",
    ]
  }

  statement {
    sid = "TfBackendObjects"
    effect = "Allow"
    actions = [
      "S3:GetObject",
      "S3:PutObject",
      "S3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::${var.tfstate_bucket}/*",
    ]
  }

  statement {
    sid = "TfStateLock"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
    ]
    resources = [
      "arn:aws:dynamodb:${var.aws_region}:*:table/${var.lock_table_name}",
    ]
  }

  statement {
    sid    = "ReadDescribe"
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "eks:Describe*",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "logs:Describe*",
      "elasticloadbalancing:Describe*",
      "autoscaling:Describe*",
      "sts:AssumeRole", # 必要に応じて
    ]
    resources = ["*"]
  }
  statement {
    sid    = "CreateUpdateDeleteDev"
    effect = "Allow"
    actions = [
      "ec2:*",
      "eks:*",
      "iam:CreateRole",
      "iam:AttachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:DeleteRole",
      "iam:PassRole",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "logs:*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "gha_permissions" {
  name        = "gha-terraform-dev-permissions"
  description = "Permissions for GitHub Actions Terraform (dev)"
  policy      = data.aws_iam_policy_document.gha_permissions.json
  tags        = local.common_tags
}

resource "aws_iam_role_policy_attachment" "gha_attach" {
  role       = aws_iam_role.gha_terraform_dev.name
  policy_arn = aws_iam_policy.gha_permissions.arn
}

output "gha_terraform_dev_role_arn" {
  value       = aws_iam_role.gha_terraform_dev.arn
  description = "Assumable role ARN for GitHub Actions (set to AWS_ROLE_TO_ASSUME_DEV)"
}
