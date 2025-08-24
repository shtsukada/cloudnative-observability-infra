variable "project" {
  description = "Project name tag"
  type = string
}

variable "env" {
  description = "Environment name tag (e.g. dev)"
  type = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type = string
}

variable "cluster_version" {
  description = "EKS version (e.g. 1.29)"
  type = string
  default = "1.29"
}

variable "vpc_id" {
  description = "VPC ID where EKS will be created"
  type = string
}

variable "private_subnets" {
  description = "Private subnet IDs for worker nodes"
  type = list(string)
}

variable "public_subnets" {
  description = "Public subnet IDs (optional, for LB etc.)"
  type = list(string)
  default = []
}

variable "endpoint_public_access" {
  description = "Enable public API endpoint"
  type = bool
  default = true
}

variable "endpoint_private_access" {
  description = "Enable private API endpoint"
  type = bool
  default = true
}

variable "node_instance_types" {
  description = "Instance types for the default managed node group"
  type = list(string)
  default = [ "t3.medium" ]
}

variable "node_desired_size" {
  description = "Desired size for the default node group"
  type = number
  default = 2
}

variable "node_min_size" {
  description = "Min size for the default node group"
  type = number
  default = 1
}

variable "node_max_size" {
  description = "Max size for the default node group"
  type = number
  default = 3
}

variable "node_disk_size" {
  description = "Node root volume size (GiB)"
  type = number
  default = 20
}

variable "aws_auth_roles" {
  description = "aws-auth role mappings"
  type = list(object({
    rolearn = string
    username = string
    groups = list(string)
  }))
  default = []
}

variable "aws_auth_users" {
  description = "aws-auth user mappings"
  type = list(object({
    userarn = string
    username = string
    groups = list(string)
  }))
  default = []
}

variable "aws_auth_accounts" {
  description = "aws-auth account IDs"
  type = list(string)
  default = []
}

variable "tags" {
  description = "Extra tags"
  type = map(string)
  default = {}
}
