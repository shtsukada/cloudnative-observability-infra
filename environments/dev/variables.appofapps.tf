variable "repo_owner" {
  description = "GitHub shtsukada/org"
  type        = string
}

variable "root_repo_url" {
  description = "app-of-appsを置くルートリポジトリ_https://github.com/shtsukada/cloudnative-observability"
  type        = string
}

variable "root_repo_revision" {
  description = "ルートリポジトリの参照(tag / branch)"
  type        = string
  default     = "main"
}

variable "allowed_namespaces" {
  description = "AppProjectで許可する配備先Namespace"
  type        = list(string)
  default     = ["argocd", "monitoring", "grpc-app"]
}

variable "source_repos_allowlist" {
  description = "AppProjectに許可するGitリポジトリURL群"
  type        = list(string)
  default     = []
}
