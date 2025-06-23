resource "google_monitoring_alert_policy" "basic_policy" {
  display_name = "High CPU Alert"
  combiner     = "OR"
  conditions {
    display_name = "VM Instance - CPU usage"
    condition_threshold {
      filter     = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.8
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  notification_channels = [var.notification_channel_id]
  project              = local.project_id
}