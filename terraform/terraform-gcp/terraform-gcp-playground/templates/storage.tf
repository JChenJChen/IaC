module "gcs_buckets" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 11.0"
  project_id = local.project_id

  buckets = [
    {
      name          = "${var.bucket_name}"
      location      = var.region
      storage_class = "STANDARD"
      force_destroy = true
    }
  ]
}