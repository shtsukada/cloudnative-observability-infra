output "vpc_id" {
  description = "VPC ID"
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR"
  value = module.vpc.vpc_cidr_block
}

output "azs" {
  description = "AZs used"
  value = module.vpc.azs
}

output "public_subnets" {
  description = "Public subnet IDs"
  value = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value = module.vpc.private_subnets
}

output "public_route_table_ids" {
  description = "Public route table IDs"
  value = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "Private route table IDs"
  value = module.vpc.private_route_table_ids
}

output "nat_public_ips" {
  description = "NAT Gateway public IPs"
  value = module.vpc.nat_public_ips
}
