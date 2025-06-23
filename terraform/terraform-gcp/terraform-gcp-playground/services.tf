locals {
  project-id = var.project_id
  sa-key = var.sa_key
  environment = var.env
  region = var.region
  zone = var.zone
#   cluster-sa = var.cluster_sa
}

resource "google_project_iam_member" "github-runner" {
  for_each = toset([
    "roles/iam.serviceAccountUser",
    "roles/run.admin",
    "roles/storage.admin",
    # "roles/pubsub.admin",
    # "roles/cloudfunctions.admin",
    # "roles/cloudsql.client",
    "roles/secretmanager.secretAccessor",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/compute.networkAdmin",
    # "roles/cloudsql.admin",
    # "roles/container.admin",
    "roles/iam.serviceAccountAdmin",
    # "roles/cloudkms.admin",
  ])

  project = local.project-id
  role = each.key
  member = local.sa-key
}

resource "google_project_service" "main" {
  for_each = toset([
    # "compute.googleapis.com",
    # "containerregistry.googleapis.com",
    "run.googleapis.com",
    # "sqladmin.googleapis.com",
    # "cloudbuild.googleapis.com",
    # "pubsub.googleapis.com",
    # "cloudfunctions.googleapis.com",
    "storage-component.googleapis.com",
    "storage-api.googleapis.com",
    "logging.googleapis.com",
    "oslogin.googleapis.com",
    "vpcaccess.googleapis.com",
    # "sql-component.googleapis.com",
    "secretmanager.googleapis.com",
    # "redis.googleapis.com",
    # "pubsub.googleapis.com",
    "servicenetworking.googleapis.com",
    # "cloudkms.googleapis.com"
  ])

  service = each.key

  project            = local.project-id
  disable_on_destroy = false
}
