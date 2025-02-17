resource "harvester_image" "k3os" {
  name      = "k3os"
  namespace = "harvester-public"
  display_name = "k3os"
  source_type  = "download"
  url          = "https://github.com/rancher/k3os/releases/download/v0.20.6-k3s1r0/k3os-amd64.iso"
}


resource "harvester_image" "alpine" {
  name       = "alpine"
  namespace  = "harvester-public"
  source_type = "download"
  url        = "https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-standard-3.18.4-x86_64.iso"
  checksum   = "sha256:c30b4de07cb71ebc9fa0175c5e14a6a6c74e9b318d99047a6136592d8425711a"
}
