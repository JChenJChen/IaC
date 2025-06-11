terraform {

  required_version = ">= 1.9.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "test-terraform-gke-20250605"
  region  = var.region
  zone    = var.zone
}