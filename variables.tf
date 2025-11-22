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

variable "agent_pool_id" {
  description = "Terraform Cloud agent pool ID"
  type        = string
}

variable "checkov_run_task_url" {
  description = "Checkov run task webhook URL"
  type        = string
  default     = ""
}

variable "checkov_hmac_key" {
  description = "HMAC key for Checkov run task authentication"
  type        = string
  sensitive   = true
  default     = ""
}
