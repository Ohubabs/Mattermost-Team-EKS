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
    config_path = "/home/ubuntu/.kube/config" #change user as needed to match the user within the instance being used to deploy the DBZ production cluster
  }

provider "helm" {
  kubernetes {
    config_path = "/home/ubuntu/.kube/config"
  }
}
