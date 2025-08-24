locals {
  name = "${var.project}-${var.env}"
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # Core
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id = var.vpc_id
  subnet_ids = var.private_subnets

  # endpoint access
  cluster_endpoint_public_access = var.endpoint_public_access
  cluster_endpoint_private_access = var.endpoint_private_access

  # IRSA
  enable_irsa = true

  # Managed node group (t3.medium, min=1,desired=2)
  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      capacity_type = "ON_DEMAND"

      min_size = var.node_min_size
      desired_size = var.node_desired_size
      max_size = var.node_max_size
      disk_size = var.node_disk_size

      subnet_ids = var.private_subnets
      labels = { "workload" = "general" }
    }
  }

  tags = merge(
    {
      "Project" = var.project
      "Env" = var.env
    },
    var.tags
  )
}

module "eks_aws_auth" {
  source = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true
  aws_auth_roles            = var.aws_auth_roles
  aws_auth_users            = var.aws_auth_users
  aws_auth_accounts         = var.aws_auth_accounts

  providers = {
    kubernetes = kubernetes
  }

  depends_on = [ module.eks ]
}
