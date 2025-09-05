variable "github_org" {
  type = string
  description = "GitHub organization/user (e.g.,shtsukada)"
}

variable "github_repo" {
  type = string
  description = "Github repository name (e.g., cloudnative-observability-infra)"
}

variable "tfstate_bucket" {
  type = string
  description = "Terraform backend S3 bucket name"
}

variable "lock_table_name" {
  type = string
  description = "Terraform backend DynamoDB lock table name"
}
