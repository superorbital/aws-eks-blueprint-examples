cluster_version        = "1.21"
zone                   = "poc"

cluster_kms_key_additional_admin_arns = []
//cluster_kms_key_additional_admin_arns = ["arn:aws:iam::000000000000:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Administrators_0000000000000000"]

map_roles      = []
/* Note: The string "aws-reserved/sso.amazonaws.com/" must be removed from any SSO ARNs added to map_roles
map_roles      = [
  {
    rolearn  = "arn:aws:iam::000000000000:role/AWSReservedSSO_Administrators_000000000000000",
    username = "sso-admin",
    groups   = ["system:masters"]
  }
]*/

platform_teams = {}
/*platform_teams = {
  cluster-admins = {
    users = [
      "arn:aws:iam::000000000000:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Administrators_000000000000000"
    ]
  }
}*/

managed_node_groups = {
  primary = {
    node_group_name = "primary"
    k8s_labels      = {
      "eks.platform.example.com/node-group-name" = "primary"
    }

    create_launch_template  = true
    launch_template_os      = "amazonlinux2eks"

    pre_userdata = <<-EOT
      date >> /creation_data.txt
    EOT

    instance_types  = ["m5.2xlarge"]
    subnet_type     = "private"
    ami_type        = "AL2_x86_64"
    capacity_type   = "ON_DEMAND"
    disk_size       = 200

    desired_size    = 3
    min_size        = 3
    max_size        = 12
    max_unavailable = 1
  }
}
