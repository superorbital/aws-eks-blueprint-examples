data "terraform_remote_state" "eks" {
  backend = "local"
  //backend = "s3"

  config = {
    path   = var.tf_state_eks_local_state_path
    /*bucket = var.tf_state_eks_s3_bucket
    key    = var.tf_state_eks_s3_key
    region = var.aws_region*/
  }

}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_id
}
