# module "vpc" {
#   source = "./../modules/vpc"

#   name                            = var.name
#   description                     = "This is prod VPC network"
#   enable_shared_vpc_host          = false
#   auto_create_subnetworks         = false
#   routing_mode                    = "REGIONAL"
#   mtu                             = 1500
#   project                         = trimprefix(local.project-id, "projects/")
#   delete_default_routes_on_create = false

#   depends_on = [
#     google_project_service.main
#   ]
#   subnets = [
#     {
#       name          = "subnet"
#       ip_cidr_range = "10.30.0.0/16"
#       region        = local.region
#     }
#   ]
# }

# resource "google_compute_network" "vpc_network" {
#   name = var.vpc_network_name
# }


module "vpc" {
  source                  = "terraform-google-modules/network/google"
  version                 = "~> 7.2"
  project_id              = local.project_id
  network_name            = var.vpc_name
  description             = "VPC network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1460

  subnets = [
    {
      subnet_name   = var.subnet_name
      subnet_ip     = "10.0.1.0/24"
      subnet_region = var.region
    }
  ]
}