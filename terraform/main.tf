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
  manifest = yamldecode(
    templatefile(
      "${path.module}/../k8s/deployment.yaml.tftpl",
      {
        image_tag = var.image_tag
      }
    )
  )
}

resource "kubernetes_manifest" "service" {
  manifest = yamldecode(file("${path.module}/../k8s/service.yaml"))
}