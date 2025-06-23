module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"
  version                = "~> 30.0"
  project_id             = local.project_id
  name                   = var.gke_name
  region                 = var.region
  network                = module.vpc.network_name
  subnetwork             = var.subnet_name
  ip_range_pods          = "pods"
  ip_range_services      = "services"
  remove_default_node_pool = true
  initial_node_count     = 1
  node_pools = [
    {
      name         = "default-node-pool"
      machine_type = "e2-medium"
      min_count    = 1
      max_count    = 3
      disk_size_gb = 100
      auto_upgrade = true
      auto_repair  = true
    }
  ]
}