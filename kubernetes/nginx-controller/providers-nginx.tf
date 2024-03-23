terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }

    kubernetes = {
      version = ">= 2.0.0"
      source  = "hashicorp/kubernetes"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
  }
}


provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

data "aws_eks_cluster" "hr-dev-eks-demo" {
  name = "hr-dev-eks-demo"
}
data "aws_eks_cluster_auth" "hr-dev-eks-demo_auth" {
  name = "hr-dev-eks-demo_auth"
}


provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "dns_zones"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "kubectl" {
  load_config_file       = false
  host                   = data.aws_eks_cluster.hr-dev-eks-demo.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.hr-dev-eks-demo.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.hr-dev-eks-demo_auth.token
  config_path            = "~/.kube/config"
}
