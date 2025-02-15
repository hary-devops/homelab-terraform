resource "harvester_image" "k3os" {
  name      = "k3os"
  namespace = "harvester-public"
  display_name = "k3os"
  source_type  = "download"
  url          = "https://github.com/rancher/k3os/releases/download/v0.20.6-k3s1r0/k3os-amd64.iso"
}
