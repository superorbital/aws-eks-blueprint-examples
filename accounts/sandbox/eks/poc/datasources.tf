data "terraform_remote_state" "vpc" {
  backend = "local"
  //backend = "s3"

  config = {
    path = var.tf_state_vpc_local_state_path
    /*bucket = var.tf_state_vpc_s3_bucket
    key    = var.tf_state_vpc_s3_key
    region = var.aws_region*/
  }

}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_blueprints.eks_cluster_id
}
