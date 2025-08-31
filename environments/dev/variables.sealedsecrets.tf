variable "sealed_secrets_chart_version" {
  type = string
  description = "bitnami-labs/sealed-secrets chart version"
  default = "2.16.2"
}

variable "sealed_secrets_namespace" {
  type = string
  description = "Namespace for sealed-secrets controller"
  default = "sealed-secrets"
}
