module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr

  # Adding descriptive tags
  common_tags = {
    Project     = var.project_name
    Environment = "production"
    ManagedBy   = "terraform"
    Owner       = "Lolo-DevOps"
    Layer       = "Networking"
  }
}



module "eks" {
  source = "./modules/eks"

  project_name    = var.project_name
  private_subnets = module.vpc.private_subnets
}


module "ecr" {
  source = "./modules/ecr"

  repository_name = "${var.project_name}-repo"
  common_tags     = var.common_tags
}