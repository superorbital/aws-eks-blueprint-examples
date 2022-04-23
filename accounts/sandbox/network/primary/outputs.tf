output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "private_subnet_ids" {
  description = "List of private subnet ids"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "List of public subnet ids"
  value       = module.vpc.public_subnets
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
