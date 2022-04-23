terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  // Tell the provider to ignore (not manage) any tags that start with `kubernetes.io/`
  // This keeps it from touching tags that EKS adds to network components for LB support.
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}
