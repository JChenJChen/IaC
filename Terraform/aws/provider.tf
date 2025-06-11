terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19"
    }
  }

  required_version = ">= 1.2.0"
}

# optional, pins TF Version. If unspecified, TF DL's latest during init
provider "aws" {
  region  = "us-west-2"
}
