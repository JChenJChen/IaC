resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.bq_dataset_id
  friendly_name               = "Main Dataset"
  description                 = "BigQuery dataset"
  location                    = var.region
  project                     = local.project_id
  delete_contents_on_destroy  = true
}