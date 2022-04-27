locals {
  eks_cluster_id               = data.terraform_remote_state.eks.outputs.eks_cluster_id
  eks_worker_security_group_id = data.terraform_remote_state.eks.outputs.eks_worker_security_group_id
  auto_scaling_group_names     = data.terraform_remote_state.eks.outputs.self_managed_node_group_autoscaling_groups
  // We'll want to be able to pass this in eventually,
  // but we are starting with it here.
  primaryNodeSelector = {
    "eks.platform.example.com/node-group-name" = "primary"
  }
}