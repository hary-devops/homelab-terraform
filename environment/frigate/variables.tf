variable "docker_host_user" {
  description = "SSH user for Docker host"
  type        = string
  default     = "harysetiawan"
}

variable "docker_host_ip" {
  description = "IP address or hostname of the Docker host"
  type        = string
  default     = "homelab"
}

variable "frigate_config_path" {
  description = "Absolute path on the Docker host for Frigate config files"
  type        = string
}

variable "frigate_storage_path" {
  description = "Absolute path on the Docker host for Frigate recording storage"
  type        = string
}

variable "frigate_rtsp_password" {
  description = "Password for RTSP streams (FRIGATE_RTSP_PASSWORD)"
  type        = string
  sensitive   = true
}

variable "frigate_devices" {
  description = "List of host device paths to pass into the container (e.g. [\"/dev/dri/renderD128\"])"
  type        = list(string)
  default     = []
}

variable "frigate_shm_size_mb" {
  description = "Shared memory size in MB (increase based on camera count)"
  type        = number
  default     = 512
}
