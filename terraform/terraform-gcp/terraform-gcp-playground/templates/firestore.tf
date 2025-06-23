resource "google_firestore_database" "default" {
  name     = "(default)"
  project  = local.project_id
  location_id = var.region
  type     = "NATIVE"
}