terraform {
  # Minimum Terraform version required
  required_version = ">= 1.0"

  # Backend Configuration: Storing state in S3 bucket
  # ⚠️ Make sure to create the bucket "terraform-state-devsecops-ebtehal" in AWS Console first!
  backend "s3" {
    bucket  = "terraform-state-devsecops-ebtehal"
    key     = "iac-actions/state.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }
  }
}