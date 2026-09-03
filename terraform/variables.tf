variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string

  validation {
    condition     = length(trimspace(var.image_tag)) > 0
    error_message = "image_tag must not be empty."
  }
}

variable "image_repository" {
  description = "Docker image repository"
  type        = string

  validation {
    condition     = length(trimspace(var.image_repository)) > 0
    error_message = "image_repository must not be empty."
  }
}

variable "app_port" {
  description = "Application container port"
  type        = number

  validation {
    condition     = var.app_port >= 1 && var.app_port <= 65535
    error_message = "app_port must be between 1 and 65535."
  }
}

variable "min_replicas" {
  description = "Minimum number of application replicas"
  type        = number
  default     = 1

  validation {
    condition     = var.min_replicas >= 1
    error_message = "min_replicas must be at least 1."
  }
}

variable "max_replicas" {
  description = "Maximum number of application replicas"
  type        = number
  default     = 3

  validation {
    condition     = var.max_replicas >= var.min_replicas
    error_message = "max_replicas must be greater than or equal to min_replicas."
  }
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "hello-server"

  validation {
    condition     = length(trimspace(var.namespace)) > 0
    error_message = "namespace must not be empty."
  }
}