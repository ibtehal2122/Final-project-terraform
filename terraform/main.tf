locals {
  common_tags = {
    Project     = var.project_name
    Environment = "production"
    ManagedBy   = "terraform"
    Owner       = "ebtehal-9"
  }
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr

  num_public_subnets  = 2
  num_private_subnets = 2
  num_nat_gateways    = 2

  common_tags = local.common_tags
}

module "eks" {
  source = "./modules/eks"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  kubernetes_version    = "1.29"
  enable_public_access  = false
  public_access_cidrs   = []
  ssh_key_name          = "my-ssh-key" # Replace with your SSH key name

  node_groups = {
    general = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      ami_type       = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"
      disk_size      = 20
      labels         = {
        "node-type" = "general-purpose"
      }
      taints = []
    }
  }

  common_tags = local.common_tags
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = "${var.project_name}-app"
  max_image_count = 10
  kms_key_arn     = null # Replace with your KMS key ARN if you want to use encryption

  common_tags = local.common_tags
}
