resource "google_api_gateway_api" "api" {
  api_id = var.api_id
}

resource "google_api_gateway_api_config" "api_config" {
  api      = google_api_gateway_api.api.id
  api_config_id = var.api_config_id
  openapi_documents {
    document {
      path     = var.openapi_spec_path
      contents = file(var.openapi_spec_path)
    }
  }
  project  = local.project_id
}

resource "google_api_gateway_gateway" "gateway" {
  gateway_id = var.gateway_id
  api_config = google_api_gateway_api_config.api_config.id
  region     = var.region
  project    = local.project_id
}