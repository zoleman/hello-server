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

locals {
  deployment = yamldecode(file("${path.module}/../k8s/deployment.yaml"))
}

resource "kubernetes_manifest" "deployment" {
  manifest = merge(local.deployment, {
    spec = merge(local.deployment.spec, {
      template = merge(local.deployment.spec.template, {
        spec = merge(local.deployment.spec.template.spec, {
          containers = [
            merge(
              local.deployment.spec.template.spec.containers[0],
              {
                image = "zoleman/hello-server:${var.image_tag}"
              }
            )
          ]
        })
      })
    })
  })
}

resource "kubernetes_manifest" "service" {
  manifest = yamldecode(file("${path.module}/../k8s/service.yaml"))
}