output "instance_name" {
  description = "Name of the created instance"
  value       = google_compute_instance.vm_instance.name
}

output "instance_id" {
  description = "ID of the created instance"
  value       = google_compute_instance.vm_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "instance_private_ip" {
  description = "Private IP address of the instance"
  value       = google_compute_instance.vm_instance.network_interface[0].network_ip
}

output "vpc_name" {
  description = "Name of the custom VPC"
  value       = google_compute_network.custom_vpc.name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh ${var.ssh_user}@${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip}"
}
