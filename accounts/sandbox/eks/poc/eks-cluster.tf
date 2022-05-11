module "eks_blueprints" {
  source  = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=f50247cb791782745315d9073509f8c5d0928dff"

  org               = var.org
  tenant            = var.tenant
  environment       = var.environment
  zone              = var.zone
  tags              = var.tags

  // NOTE: Add-ons are not updated automatically when the cluster is updated.
  // You will need to do this at the appropriate time for each addon, if it is required.
  // See: https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/docs/add-ons/index.md
  terraform_version = var.terraform_version

  # KMS
  cluster_kms_key_additional_admin_arns = var.cluster_kms_key_additional_admin_arns

  # Auth
  map_roles         = var.map_roles
  application_teams = var.application_teams
  platform_teams    = var.platform_teams

  # EKS Cluster VPC and Subnets
  vpc_id             = local.vpc_id
  private_subnet_ids = local.private_subnet_ids
  //public_subnet_ids  = local.public_subnet_ids

  # EKS CONTROL PLANE VARIABLES
  cluster_version                  = var.cluster_version
  cluster_endpoint_private_access  = false
  cluster_endpoint_public_access   = true

  # EKS MANAGED NODE GROUPS
  managed_node_groups = var.managed_node_groups

  # Change these according to your security requirements if needed
  node_security_group_additional_rules = {
   # Extend node-to-node security group rules.
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    #Outbound traffic for Node groups
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    # Allows Control Plane Nodes to talk to Worker nodes on all ports.
    ingress_cluster_to_node_all_traffic = {
      description                   = "Cluster API to Nodegroup all traffic"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
}

# Tag the VPC and subnets for this cluster
# Ensure that the VPC module will not remove these
# by seting the AWS provider to ignore all kubernetes.io/ tags.
resource "aws_ec2_tag" "vpc_tag" {
  resource_id = local.vpc_id
  key         = "kubernetes.io/cluster/${module.eks_blueprints.eks_cluster_id}"
  value       = "shared"
}

resource "aws_ec2_tag" "private_subnet_tag" {
  for_each    = toset(local.private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "private_subnet_cluster_tag" {
  for_each    = toset(local.private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${module.eks_blueprints.eks_cluster_id}"
  value       = "shared"
}

resource "aws_ec2_tag" "public_subnet_tag" {
  for_each    = toset(local.public_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "public_subnet_cluster_tag" {
  for_each    = toset(local.public_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${module.eks_blueprints.eks_cluster_id}"
  value       = "shared"
}
