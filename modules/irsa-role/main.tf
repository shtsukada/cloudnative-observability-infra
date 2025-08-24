locals {
  issuer_host = replace(var.oidc_issuer_url, "https://", "")
}

data "aws_iam_policy_document" "trust" {
  statement {
    effect = "Allow"
    actions = [ "sts:AssumeRoleWithWebIdentity" ]

    principals {
      type = "Federated"
      identifiers = [ var.oidc_provider_arn ]
    }

    condition {
      test = "StringEquals"
      variable = "${local.issuer_host}:sub"
      values = [ "system:serviceaccount:${var.namespace}:${var.service_account}" ]
    }

      condition {
      test = "StringEquals"
      variable = "${local.issuer_host}:aud"
      values = [ "sts.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role" "this" {
  name = "irsa-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.trust.json
  tags = var.tags
}

resource "aws_iam_policy" "inline" {
  count = var.policy_json == null ? 0 : 1
  name = "irsa-${var.name}-inline"
  description = "Inline policy for ${var.name}"
  policy = var.policy_json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "inline_attach" {
  count = var.policy_json == null ? 0 : 1
  role = aws_iam_role.this.name
  policy_arn = aws_iam_policy.inline[0].arn
}

resource "aws_iam_role_policy_attachment" "managed_attach" {
  for_each = toset(var.policy_arns)
  role = aws_iam_role.this.name
  policy_arn = each.value
}

resource "kubernetes_namespace" "ns" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "sa" {
  count = var.create_service_account ? 1 : 0

  metadata {
    name = var.service_account
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}
