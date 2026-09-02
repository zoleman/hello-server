terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

resource "kubernetes_manifest" "deployment" {
  manifest = yamldecode(file("${path.module}/../k8s/deployment.yaml"))
}

resource "kubernetes_manifest" "service" {
  manifest = yamldecode(file("${path.module}/../k8s/service.yaml"))
}