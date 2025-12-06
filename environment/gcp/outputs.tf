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

output "monitoring_dashboard_url" {
  description = "URL to the GCP Monitoring Dashboard"
  value       = "https://console.cloud.google.com/monitoring/dashboards?project=${var.project_id}"
}

output "alert_policies" {
  description = "Alert policies created"
  value = {
    cpu_warning         = google_monitoring_alert_policy.cpu_warning.id
    cpu_critical        = google_monitoring_alert_policy.cpu_critical.id
    memory_warning      = google_monitoring_alert_policy.memory_warning.id
    memory_critical     = google_monitoring_alert_policy.memory_critical.id
    disk_usage_warning  = google_monitoring_alert_policy.disk_usage_warning.id
    disk_usage_critical = google_monitoring_alert_policy.disk_usage_critical.id
    disk_io_critical    = google_monitoring_alert_policy.disk_io_critical.id
    instance_down       = google_monitoring_alert_policy.instance_down.id
  }
}

output "notification_channel" {
  description = "Email notification channel"
  value       = google_monitoring_notification_channel.email.id
}
