resource "harvester_virtualmachine" "alpine" {
  name                 = "alpine"
  namespace            = "harvester-public"
  restart_after_update = true

  description = "Test Alpine raw image"
  tags = {
    ssh-user = "alpine"
  }

  cpu    = 2
  memory = "2Gi"

  efi         = true
  secure_boot = true

  run_strategy    = "RerunOnFailure"
  hostname        = "alpine"
  reserved_memory = "100Mi"
  machine_type    = "q35"

  network_interface {
    name           = "nic-1"
    wait_for_lease = true
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = "10Gi"
    bus        = "virtio"
    boot_order = 1

    image       = data.harvester_image.alpine
    auto_delete = true
  }

  disk {
    name        = "emptydisk"
    type        = "disk"
    size        = "20Gi"
    bus         = "virtio"
    auto_delete = true
  }

  cloudinit {
    user_data_secret_name    = data.harvester_cloudinit_secret.vm-cloud-init
    network_data_secret_name = data.harvester_cloudinit_secret.network-config-alpine.name

  }
}
