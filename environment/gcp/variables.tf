variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region (asia-southeast1 for Singapore or asia-southeast2 for Jakarta)"
  type        = string
  default     = "asia-southeast1" # Singapore
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "asia-southeast1-a" # Singapore zone
}

variable "instance_name" {
  description = "Name of the VM instance"
  type        = string
  default     = "homelab-vm"
}

variable "machine_type" {
  description = "Machine type (2 vCPU, 4GB RAM)"
  type        = string
  default     = "e2-medium" # 2 vCPU, 4GB RAM
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

variable "os_image" {
  description = "Operating system image"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts" # Ubuntu 22.04 LTS
  # Alternative options:
  # "debian-cloud/debian-12"     # Debian 12
  # "centos-cloud/centos-stream-9" # CentOS Stream 9
}

variable "ssh_user" {
  description = "SSH username for instance access"
  type        = string
  default     = "admin"
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
  default     = ""
  sensitive   = true
}

variable "startup_script" {
  description = "Startup script to run on instance creation"
  type        = string
  default     = ""
}
