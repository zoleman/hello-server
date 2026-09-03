variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string

validation {
    condition     = length(trimspace(var.image_tag)) > 0
    error_message = "image_tag must not be empty."
  }
}