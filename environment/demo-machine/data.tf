data "harvester_cloudinit_secret" "vm-cloud-init" {
  name      = "vm-cloud-init"
  namespace = "harvester-public"
}


data "harvester_cloudinit_secret" "network-config-alpine" {
  name      = "network-config-alpine"
  namespace = "harvester-public"
}


data "harvester_image" "alpine" {
  name      = "alpine"
  namespace = "harvester-public"
}
