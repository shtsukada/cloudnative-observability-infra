output "cluster_name" {
  description = "EKS cluster name"
  value = module.eks.cluster_name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "EKS API server endpoint"
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded cluster CA"
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA"
  value = module.eks.oidc_provider_arn
}

output "managed_node_group_names" {
  description = "EKS managed node group names"
  value = keys(module.eks.eks_managed_node_groups)
  }
