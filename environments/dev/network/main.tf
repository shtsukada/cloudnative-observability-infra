locals {
  common_tags = {
    Project   = var.project
    Env       = var.env
    ManagedBy = "Terraform"
    Component = "network"
  }

  eks_cluster_tag_key = "kubernetes.io/cluster/${var.cluster_name}"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8"

  name = "${var.project}-${var.env}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  create_igw = true

  map_public_ip_on_launch = true

  public_subnet_tags = merge(
    local.common_tags,
    {
      Name                        = "${var.project}-${var.env}-public"
      "kubernetes.io/role/elb"    = 1
      (local.eks_cluster_tag_key) = "shared"
    }
  )

  private_subnet_tags = merge(
    local.common_tags,
    {
      Name                              = "${var.project}-${var.env}-private"
      "kubernetes.io/role/internal-elb" = 1
      (local.eks_cluster_tag_key)       = "shared"
    }
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.env}-vpc"
    }
  )
}
