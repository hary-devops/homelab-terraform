variable "github_app_installation_id" {
  description = "GitHub App Installation ID for Terraform Cloud VCS integration"
  type        = string
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
