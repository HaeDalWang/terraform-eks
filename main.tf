terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.4.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }
}

########## Providers ##########
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
provider "aws" {
  region = "ap-northeast-2"
}
provider "kubectl" {
  config_paths = "~/.kube/config"
}