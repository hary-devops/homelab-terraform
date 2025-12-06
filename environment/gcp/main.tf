# Custom VPC Network
resource "google_compute_network" "custom_vpc" {
  name                    = "homelab-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Subnet in Singapore region
resource "google_compute_subnetwork" "subnet" {
  name          = "homelab-subnet-singapore"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.custom_vpc.id
  project       = var.project_id

  private_ip_google_access = true
}

# Firewall rule - Allow SSH
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.custom_vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

# Firewall rule - Allow internal traffic
resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.custom_vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.1.0/24"]
}

# VM Instance
resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type # e2-medium (2 vCPU, 4GB RAM)
  zone         = var.zone
  project      = var.project_id

  tags = ["ssh"]

  boot_disk {
    initialize_params {
      image = var.os_image  # Ubuntu 22.04 LTS
      size  = var.disk_size # 20 GB
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.custom_vpc.name
    subnetwork = google_compute_subnetwork.subnet.name

    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = var.ssh_public_key != "" ? "${var.ssh_user}:${var.ssh_public_key}" : null
  }

  metadata_startup_script = var.startup_script != "" ? var.startup_script : <<-EOF
    #!/bin/bash
    # Install Cloud Ops Agent for enhanced monitoring
    curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
    sudo bash add-google-cloud-ops-agent-repo.sh --also-install
    
    # Configure ops agent to collect system metrics
    sudo systemctl enable google-cloud-ops-agent
    sudo systemctl start google-cloud-ops-agent
    
    echo "Cloud Ops Agent installed successfully"
  EOF

  labels = {
    environment = "homelab"
    managed_by  = "terraform"
  }
}
