module "network" {
  source     = "./network"
  project    = var.project
  env        = var.env
  aws_region = var.aws_region
}
