terraform {

  required_version = ">= 1.9.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0, < 6.0.0"
    }
  }
}

provider "google" {
  project = "test-terraform-gke-20250605"
  region  = var.region
  zone    = var.zone
}