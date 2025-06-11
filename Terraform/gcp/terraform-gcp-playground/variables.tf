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
