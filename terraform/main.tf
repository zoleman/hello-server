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
  deployment           = yamldecode(file("${path.module}/../k8s/deployment.yaml"))
  deployment_container = local.deployment.spec.template.spec.containers[0]
  service              = yamldecode(file("${path.module}/../k8s/service.yaml"))
}

resource "kubernetes_manifest" "deployment" {
  manifest = merge(local.deployment, {
    spec = merge(local.deployment.spec, {
      template = merge(local.deployment.spec.template, {
        spec = merge(local.deployment.spec.template.spec, {
          containers = [
            merge(local.deployment_container, {

              # Docker image
              image = "${var.image_repository}:${var.image_tag}"

              # Environment passed into the Go application
              env = [
                {
                  name  = "APP_PORT"
                  value = tostring(var.app_port)
                }
              ]

              # Kubernetes container port
              ports = [
                merge(local.deployment_container.ports[0], {
                  containerPort = var.app_port
                })
              ]

              # Health check port
              livenessProbe = merge(local.deployment_container.livenessProbe, {
                httpGet = merge(local.deployment_container.livenessProbe.httpGet, {
                  port = var.app_port
                })
              })

              # Readiness check port
              readinessProbe = merge(local.deployment_container.readinessProbe, {
                httpGet = merge(local.deployment_container.readinessProbe.httpGet, {
                  port = var.app_port
                })
              })
            })
          ]
        })
      })
    })
  })
}

resource "kubernetes_manifest" "service" {
  manifest = merge(local.service, {
    spec = merge(local.service.spec, {
      ports = [
        merge(local.service.spec.ports[0], {
          targetPort = var.app_port
        })
      ]
    })
  })
}