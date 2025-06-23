module "cloudsql" {
  source     = "terraform-google-modules/sql-db/google"
  version    = "~> 15.0"
  project_id = local.project_id
  name       = var.cloudsql_name
  region     = var.region

  tier              = "db-f1-micro"
  database_version  = "POSTGRES_14"
  deletion_protection = false

  users = [
    {
      name     = "dbuser"
      password = var.db_password
    }
  ]
  databases = [
    {
      name = "defaultdb"
    }
  ]
}