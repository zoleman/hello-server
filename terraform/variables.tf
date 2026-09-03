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