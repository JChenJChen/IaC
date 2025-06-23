variable "project_id" {
  type = string
}

variable "sa_key" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_network_name" {
  type = string
}

variable "tf_backend_bucket" {
  description = "tfstate backend GCS bucket name"
  type        = string
}

variable "tf_backend_prefix" {
  description = "tfstate backend GCS bucket prefix"
  type        = string
}

variable "region" {
  default = "us-east4"
  type    = string
}

variable "zone" {
  default = "us-east4-a"
  type    = string
}

# variable "cluster_sa" {
#   type = string
# }

variable "vpc_name"          { default = "main-vpc" }
variable "subnet_name"       { default = "main-subnet" }
variable "gke_name"          { default = "main-gke" }
variable "owner_email"       { default = "owner@example.com" }
variable "editor_email"      { default = "editor@example.com" }
# variable "bucket_name"       { default = "main-bucket" }
# variable "cloudsql_name"     { default = "main-db" }
# variable "db_password"       {}
# variable "pubsub_topic_name" { default = "main-topic" }
# variable "pubsub_subscription_name" { default = "main-sub" }
# variable "bq_dataset_id"     { default = "main_dataset" }
# variable "function_name"     { default = "main-function" }
# variable "source_directory"  { default = "./function-source" }
# variable "api_id"            { default = "main-api" }
# variable "api_config_id"     { default = "main-config" }
# variable "openapi_spec_path" { default = "openapi.yaml" }
# variable "gateway_id"        { default = "main-gateway" }
# variable "cloud_run_service_name" { default = "main-run" }
# variable "container_image"   { default = "gcr.io/cloudrun/hello" }
variable "notification_channel_id" {default = "test"}
# variable "cloudbuild_trigger_name" { default = "main-trigger" }
# variable "repo_name"         { default = "main-repo" }