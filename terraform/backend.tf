terraform {

  required_version = ">= 1.6"

  backend "s3" {

    bucket         = "terraform-state-devsecops-ebtehal"

    key            = "eks/terraform.tfstate"

    region         = "us-east-1"

    encrypt        = true

    dynamodb_table = "terraform-locks" 

  }

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.7"

    }

    kubernetes = {

      source  = "hashicorp/kubernetes"

      version = "~> 2.29"

    }

    helm = {

      source  = "hashicorp/helm"

      version = "~> 2.12"

    }

  }

}