module "cloudfunctions" {
  source  = "GoogleCloudPlatform/cloud-functions/google"
  version = "~> 0.2"
  project = local.project_id
  region  = var.region
  name    = var.function_name
  runtime = "python311"
  entry_point = "hello_world"
  source_directory = var.source_directory
  trigger_http = true
  available_memory_mb = 256
  environment_variables = {
    ENV = "dev"
  }
}