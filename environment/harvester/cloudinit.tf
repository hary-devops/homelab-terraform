resource "harvester_cloudinit_secret" "vm-cloud-init" {
  name      = "vm-cloud-init"
  namespace = "harvester-public"

  user_data    = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - nginx
      - docker
      - bash

    users:
      - name: ubuntu
        shell: /bin/sh
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
          - YOUR_PUBLIC_SSH_KEY_HERE
        lock_passwd: true

    runcmd:
      - rc-update add nginx default
      - rc-service nginx start
      - rc-update add docker default
      - rc-service docker start
      - adduser ubuntu docker
      - sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
      - rc-service sshd restart

    EOF
  network_data = ""
}


resource "harvester_cloudinit_secret" "network-config-alpine" {
  name      = "network-config-alpine"
  namespace = "harvester-public"

  network_data = <<EOT
version: 2
ethernets:
  eth0:
    dhcp4: true
    dhcp6: false
    optional: true
EOT
}
