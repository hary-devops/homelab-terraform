# Notification Channel - Email
resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notification Channel"
  type         = "email"
  project      = var.project_id

  labels = {
    email_address = var.alert_email
  }

  enabled = true

  # Ensure APIs are enabled before creating notification channel
  depends_on = [
    google_project_service.monitoring_api,
    google_project_service.pubsub_api
  ]
}

# Alert Policy - CPU Usage Critical
resource "google_monitoring_alert_policy" "cpu_critical" {
  display_name = "VM CPU Usage Critical (≥85%)"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "CPU utilization above 85% for 5 minutes"

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND resource.labels.instance_id = \"${google_compute_instance.vm_instance.instance_id}\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
      duration        = "300s" # 5 minutes
      comparison      = "COMPARISON_GT"
      threshold_value = 0.85 # 85%

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  alert_strategy {
    auto_close = "1800s" # Auto close after 30 minutes if resolved
  }

  documentation {
    content   = "CPU usage has exceeded 85% for 5 minutes on ${var.instance_name}. This indicates high CPU load that may impact performance."
    mime_type = "text/markdown"
  }
}

# Alert Policy - CPU Usage Warning
resource "google_monitoring_alert_policy" "cpu_warning" {
  display_name = "VM CPU Usage Warning (≥70%)"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "CPU utilization above 70% for 5 minutes"

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND resource.labels.instance_id = \"${google_compute_instance.vm_instance.instance_id}\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
      duration        = "300s" # 5 minutes
      comparison      = "COMPARISON_GT"
      threshold_value = 0.70 # 70%

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "CPU usage has exceeded 70% for 5 minutes on ${var.instance_name}. Monitor the situation as it approaches critical levels."
    mime_type = "text/markdown"
  }
}

# Alert Policy - Memory Usage Critical
resource "google_monitoring_alert_policy" "memory_critical" {
  display_name = "VM Memory Usage Critical (≥90%)"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Memory utilization above 90% for 5 minutes"

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND resource.labels.instance_id = \"${google_compute_instance.vm_instance.instance_id}\" AND metric.type = \"agent.googleapis.com/memory/percent_used\""
      duration        = "300s" # 5 minutes
      comparison      = "COMPARISON_GT"
      threshold_value = 90 # 90%

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Memory usage has exceeded 90% for 5 minutes on ${var.instance_name}. System may start using swap space heavily. Risk of OOM (Out of Memory) errors."
    mime_type = "text/markdown"
  }
}

# Alert Policy - Memory Usage Warning
resource "google_monitoring_alert_policy" "memory_warning" {
  display_name = "VM Memory Usage Warning (≥75%)"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Memory utilization above 75% for 5 minutes"

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND resource.labels.instance_id = \"${google_compute_instance.vm_instance.instance_id}\" AND metric.type = \"agent.googleapis.com/memory/percent_used\""
      duration        = "300s" # 5 minutes
      comparison      = "COMPARISON_GT"
      threshold_value = 75 # 75%

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Memory usage has exceeded 75% for 5 minutes on ${var.instance_name}. Monitor memory consumption closely."
    mime_type = "text/markdown"
  }
}

# Alert Policy - Disk Usage Critical
resource "google_monitoring_alert_policy" "disk_usage_critical" {
  display_name = "VM Disk Usage Critical (≥85%)"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Disk utilization above 85%"

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND resource.labels.instance_id = \"${google_compute_instance.vm_instance.instance_id}\" AND metric.type = \"agent.googleapis.com/disk/percent_used\" AND metric.labels.device != \"loop\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 85 # 85%

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MAX"
        group_by_fields      = ["metric.device"]
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Disk usage has exceeded 85% on ${var.instance_name}. Critical: Risk of disk full errors. Clean up or expand disk immediately."
    mime_type = "text/markdown"
  }
}

# Alert Policy - Disk Usage Warning
resource "google_monitoring_alert_policy" "disk_usage_warning" {
  display_name = "VM Disk Usage Warning (≥75%)"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Disk utilization above 75%"

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND resource.labels.instance_id = \"${google_compute_instance.vm_instance.instance_id}\" AND metric.type = \"agent.googleapis.com/disk/percent_used\" AND metric.labels.device != \"loop\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 75 # 75%

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MAX"
        group_by_fields      = ["metric.device"]
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Disk usage has exceeded 75% on ${var.instance_name}. Plan for cleanup or disk expansion."
    mime_type = "text/markdown"
  }
}

# Alert Policy - Disk I/O Utilization Critical
resource "google_monitoring_alert_policy" "disk_io_critical" {
  display_name = "VM Disk I/O Utilization Critical (≥85%)"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Disk I/O utilization above 85% for 5 minutes"

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND resource.labels.instance_id = \"${google_compute_instance.vm_instance.instance_id}\" AND metric.type = \"agent.googleapis.com/disk/io_time\""
      duration        = "300s" # 5 minutes
      comparison      = "COMPARISON_GT"
      threshold_value = 85 # 85%

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_MAX"
        group_by_fields      = ["metric.device"]
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Disk I/O utilization has exceeded 85% for 5 minutes on ${var.instance_name}. High disk I/O wait times may cause application slowdowns."
    mime_type = "text/markdown"
  }
}

# Alert Policy - Disk Read Latency Critical
resource "google_monitoring_alert_policy" "disk_read_latency" {
  display_name = "VM Disk Read Latency Critical (>50ms)"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Disk read latency above 50ms for 5 minutes"

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND resource.labels.instance_id = \"${google_compute_instance.vm_instance.instance_id}\" AND metric.type = \"compute.googleapis.com/instance/disk/read_ops_count\""
      duration        = "300s" # 5 minutes
      comparison      = "COMPARISON_GT"
      threshold_value = 0.05 # 50ms

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_DELTA"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Disk read latency has exceeded 50ms for 5 minutes on ${var.instance_name}. High latency indicates disk performance issues."
    mime_type = "text/markdown"
  }
}

# Alert Policy - Instance Uptime (Instance Down)
resource "google_monitoring_alert_policy" "instance_down" {
  display_name = "VM Instance Down"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Instance is not running"

    condition_threshold {
      filter          = "resource.type = \"gce_instance\" AND resource.labels.instance_id = \"${google_compute_instance.vm_instance.instance_id}\" AND metric.type = \"compute.googleapis.com/instance/uptime\""
      duration        = "60s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MAX"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "VM instance ${var.instance_name} is down or not responding. Immediate attention required."
    mime_type = "text/markdown"
  }
}
