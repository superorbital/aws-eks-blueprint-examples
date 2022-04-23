output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = module.eks_blueprints.configure_kubectl
}

output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks_blueprints.eks_cluster_id
}

output "eks_worker_security_group_id" {
  description = "EKS worker security group ID"
  value       = module.eks_blueprints.worker_node_security_group_id
}

output "managed_node_groups" {
  description = "EKS Managed node groups"
  value       = module.eks_blueprints.managed_node_groups
}
