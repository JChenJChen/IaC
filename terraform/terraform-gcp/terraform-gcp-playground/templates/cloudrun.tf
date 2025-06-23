resource "google_cloud_run_service" "service" {
  name     = var.cloud_run_service_name
  location = var.region
  template {
    spec {
      containers {
        image = var.container_image
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}