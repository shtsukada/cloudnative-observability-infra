locals {
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer_url = module.eks.cluster_oidc_issuer_url

  tags = {
    Project = "cloudnative-observability"
    Env = "dev"
  }
}

# Argo CD:s3読取(helmリポジトリ)
variable "argocd_s3_bucket_name" {
  type = string
  description = "Argo CDがHelm Chartを取得するS3バケット名(read-only)"
}

data "aws_iam_policy_document" "argocd_s3_ro" {
  statement {
    sid = "ListBucket"
    effect = "Allow"
    actions = [ "s3:ListBucket" ]
    resources = [
      "arn:aws:s3:::${var.argocd_s3_bucket_name}"
    ]
  }
  statement {
    sid = "GetObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
     ]
     resources = [
      "arn:aws:s3:::${var.argocd_s3_bucket_name}/*"
     ]
  }
}

module "irsa_argocd" {
  source = "../../modules/irsa-role"
  name = "argocd-app-controller"
  namespace = "argocd"
  service_account = "argocd-application-controller"
  oidc_provider_arn = local.oidc_provider_arn
  oidc_issuer_url = local.oidc_issuer_url
  policy_json = data.aws_iam_policy_document.argocd_s3_ro.json
  policy_arns = []
  create_namespace = false
  create_service_account = false
  tags = local.tags
}

variable "sealed_secrets_backup_bucket" {
  type = string
  description = "Sealed Secretsの鍵バックアップ用S3バケット"
}

data "aws_iam_policy_document" "sealed_s3_rw" {
  statement {
    sid = "ListBucket"
    effect = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.sealed_secrets_backup_bucket}"
    ]
  }
  statement {
    sid = "PutGetObjects"
    effect = "Allow"
    actions = [ "s3:GetObject", "s3:PutObject" ]
    resources = [
      "arn:aws:s3:::${var.sealed_secrets_backup_bucket}/*"
    ]
  }
}

module "irsa_sealed_secrets" {
  source = "../../modules/irsa-role"
  name = "sealed-secrets-controller"
  namespace = "sealed-secrets"
  service_account = "sealed-secrets-controller"
  oidc_provider_arn = local.oidc_provider_arn
  oidc_issuer_url = local.oidc_issuer_url
  policy_json = data.aws_iam_policy_document.sealed_s3_rw.json
  policy_arns = []
  create_namespace = true
  create_service_account = true
  tags = local.tags
}

# OpenTelemetry Collector: CloudWatch Logs & X-Ray (任意)

variable "otelcloudwatch_log_group_arn" {
  type = string
  description = "Otel Collectorが出力するCloudWatch LogsのLogGroup ARN"
  default = "null"
}

locals {
  otel_managed_policies = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  ]
}

module "irsa_otel" {
  source = "../../modules/irsa-role"
  name = "otel-collector"
  namespace = "monitoring"
  service_account = "otel-collector"
  oidc_provider_arn = local.oidc_provider_arn
  oidc_issuer_url = local.oidc_issuer_url
  policy_json = null
  policy_arns = local.otel_managed_policies
  create_namespace = true
  create_service_account = true
  tags = local.tags
}
