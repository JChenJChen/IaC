resource "google_cloudbuild_trigger" "trigger" {
  name        = var.cloudbuild_trigger_name
  description = "Trigger for CI/CD"
  trigger_template {
    branch_name = "main"
    repo_name   = var.repo_name
  }
  filename    = "cloudbuild.yaml"
  project     = local.project_id
}