module "eks" {
  source = "./eks"

  project = var.project
  env     = var.env

  cluster_name    = "grpc-observability-cluster"
  cluster_version = "1.29"

  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  public_subnets  = module.network.public_subnets

  endpoint_public_access  = true
  endpoint_private_access = true

  aws_auth_roles    = []
  aws_auth_users    = []
  aws_auth_accounts = []

  providers = {
    kubernetes = kubernetes.eks
  }
}
