module "iam" {
  source     = "terraform-google-modules/iam/google//modules/projects_iam"
  version    = "~> 7.7"
  projects   = [local.project_id]
  bindings   = {
    "roles/owner" = [
      var.owner_email
    ]
    "roles/editor" = [
      var.editor_email
    ]
  }
}