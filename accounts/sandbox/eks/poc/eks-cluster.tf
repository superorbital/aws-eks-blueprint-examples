module "eks_blueprints" {
  //source  = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=34921232356fb69b5a41094246d488c37c596d97"

  // FIXME:
  // We are using this fork at the moment due to this bug:
  // https://github.com/aws-ia/terraform-aws-eks-blueprints/issues/428
  // We will switch back soon after the related PR is merged.
  source = "github.com/spkane/terraform-aws-eks-blueprints?ref=mng-launch-templates"

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
}
