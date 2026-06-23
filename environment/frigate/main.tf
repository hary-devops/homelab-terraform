resource "docker_image" "frigate" {
  name         = "ghcr.io/blakeblackshear/frigate:stable"
  keep_locally = true
}

resource "docker_container" "frigate" {
  name         = "frigate"
  image        = docker_image.frigate.image_id
  restart      = "unless-stopped"
  privileged   = true
  stop_timeout = 30
  shm_size     = var.frigate_shm_size_mb * 1024 * 1024

  env = [
    "FRIGATE_RTSP_PASSWORD=${var.frigate_rtsp_password}",
  ]

  volumes {
    host_path      = "/etc/localtime"
    container_path = "/etc/localtime"
    read_only      = true
  }

  volumes {
    host_path      = var.frigate_config_path
    container_path = "/config"
  }

  volumes {
    host_path      = var.frigate_storage_path
    container_path = "/media/frigate"
  }

  mounts {
    target = "/tmp/cache"
    type   = "tmpfs"
    tmpfs_options {
      size_bytes = 1000000000
    }
  }

  dynamic "devices" {
    for_each = var.frigate_devices
    content {
      host_path      = devices.value
      container_path = devices.value
    }
  }

  ports {
    internal = 8971
    external = 8971
  }

  ports {
    internal = 8554
    external = 8554
  }

  ports {
    internal = 8555
    external = 8555
    protocol = "tcp"
  }

  ports {
    internal = 8555
    external = 8555
    protocol = "udp"
  }
}
