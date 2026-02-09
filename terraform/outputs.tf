# ECR Outputs
output "ecr_repo_url" {
  description = "Copy this to your GitHub Actions secrets"
  value       = module.ecr.repository_url
}

# VPC Outputs (Needed for Bastion or Troubleshooting)
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

# EKS Outputs (Crucial for kubectl and Ansible)
output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_certificate_authority" {
  value     = module.eks.cluster_ca
  sensitive = true # معلومة حساسة نطلعها فقط عند الحاجة
}