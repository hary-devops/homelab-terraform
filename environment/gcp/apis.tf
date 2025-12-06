# Enable required GCP APIs for monitoring and alerting

# Cloud Monitoring API (required for alert policies and dashboards)
resource "google_project_service" "monitoring_api" {
  project = var.project_id
  service = "monitoring.googleapis.com"

  disable_on_destroy = false
}

# Cloud Pub/Sub API (required for notification channels)
resource "google_project_service" "pubsub_api" {
  project = var.project_id
  service = "pubsub.googleapis.com"

  disable_on_destroy = false
}

# Compute Engine API (required for VM instances)
resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

# Cloud Resource Manager API (for project management)
resource "google_project_service" "cloudresourcemanager_api" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_on_destroy = false
}

# Service Usage API (for enabling other APIs)
resource "google_project_service" "serviceusage_api" {
  project = var.project_id
  service = "serviceusage.googleapis.com"

  disable_on_destroy = false
}
