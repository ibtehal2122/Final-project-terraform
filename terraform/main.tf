provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

# --- 1. VPC Module (ده الجزء اللي كان ناقص!) ---
module "vpc" {
  source = "./modules/vpc"

  # التاجات دي هتشتغل لو ضفتي متغير tags في modules/vpc/variables.tf زي ما اتفقنا
  tags = {
    Environment = "Dev"
  }
}

# --- 2. EKS Module ---
module "eks" {
  source = "./modules/eks"

  cluster_name    = "devsecops-cluster"
  k8s_version     = "1.30"

  # هنا بنربط مع الـ VPC اللي عرفناه فوق
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnet_ids
  control_plane_subnet_ids = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)

  instance_types = ["t3.small"]
  desired_size   = 2
  min_size       = 1
  max_size       = 3

  tags = {
    Environment = "Dev"
    Project     = "DevSecOps"
  }
}

# --- 3. ECR Module ---
module "ecr" {
  source = "./modules/ecr"

  repository_names = [
    "devsecops-backend",
    "devsecops-frontend"
  ]

  tags = {
    Environment = "Dev"
    Project     = "DevSecOps"
  }
}