terraform {
  backend "gcs" {
  # bucket = var.tf_backend_bucket
  # prefix = var.tf_backend_prefix
  bucket = "test-infra-tfstate"
  prefix = "general/test"
  }
}
