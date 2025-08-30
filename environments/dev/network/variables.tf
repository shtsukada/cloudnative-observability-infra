variable "project" {
  description = "Project name tag (e.g., cloudnative-observability)"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev/stg/prd)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.20.0.0/16"
}

variable "azs" {
  description = "Availability Zones to use"
  type        = list(string)
  # ap-northeast-1 の3AZ例（アカウントで利用可なAZに合わせて調整可）
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "public_subnets" {
  description = "Public subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.20.0.0/20", "10.20.16.0/20", "10.20.32.0/20"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.20.128.0/20", "10.20.144.0/20", "10.20.160.0/20"]
}

variable "cluster_name" {
  description = "EKS cluster name to tag subnets for"
  type        = string
  default     = "grpc-observability-cluster"
}
