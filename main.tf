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
  config_path = "~/.kube/config"
}

#### 기본 로컬 정보 #####
locals {
  name         = "eks-bsd"
  cluster_name = coalesce(var.cluster_name, local.name)
  region       = "ap-northeast-2"
}