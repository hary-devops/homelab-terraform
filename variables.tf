variable "github_app_installation_id" {
  description = "Terraform Cloud GitHub App installation ID (the ghain-xxxxxxxx value, NOT the numeric GitHub installation ID)"
  type        = string

  validation {
    condition     = startswith(var.github_app_installation_id, "ghain-")
    error_message = "Must be the Terraform Cloud GitHub App installation ID in the form 'ghain-xxxxxxxx', not the numeric GitHub installation ID."
  }
}

variable "docker_host_user" {
  description = "SSH user for Docker host connection"
  type        = string
  default     = "harysetiawan"
}

variable "docker_host_ip" {
  description = "IP address or hostname of the Docker host"
  type        = string
  default     = "192.168.18.28"
}