terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
  }
}

provider "aws" {
    region = "us-east-2"
}

provider "kubernetes" {
  config_path = "/home/ubuntu/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "/home/ubuntu/.kube/config"
  }
}