variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "oidc_issuer_url" {
  type = string
}

variable "policy_json" {
  type = string
  description = "(任意)インラインIAMポリシー(JSON)。空なら作成しない"
  default = null
}

variable "policy_arns" {
  type = list(string)
  description = "(任意)既存のマネージドポリシーARNをアタッチする場合"
  default = []
}

variable "create_service_account" {
  type = bool
  default = true
}

variable "create_namespace" {
  type = bool
  default = true
}

variable "tags" {
  type = map(string)
  default = {}
}
