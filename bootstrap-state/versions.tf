terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~>5.60"}
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project = var.project
      Environment = var.env
      ManagedBy = "Terraform"
      Component = "bootstrap-state"
    }
  }
}
