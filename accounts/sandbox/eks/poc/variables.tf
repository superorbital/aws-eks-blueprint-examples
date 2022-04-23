variable "aws_profile" {
  type        = string
  description = "AWS profile name"
  default     = "sandbox"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "cluster_version" {
  type        = string
  description = "K8S version"
}

variable "terraform_version" {
  type        = string
  description = "The version of terraform used (e.g. Terraform v1.1.9)"
}

variable "tf_state_vpc_local_state_path" {
  type        = string
  description = "Relative path to the VPC Terraform state"
}

/*variable "tf_state_vpc_s3_bucket" {
  type        = string
  description = "S3 bucket name for VPC Terraform state"
}

variable "tf_state_vpc_s3_key" {
  type        = string
  description = "S3 bucket key name for VPC Terraform state"
}*/

variable "org" {
  type        = string
  description = "organization name, e.g. examplecorp'"

  validation {
    condition     = can(regex("^[0-9A-Za-z][A-Za-z0-9\\-_]+$", var.org))
    error_message = "The 'org' variable must meet these regex \"^[0-9A-Za-z][A-Za-z0-9\\-_]+$\" requirements."
  }

}

variable "tenant" {
  type        = string
  description = "Account Name or unique account unique identifier"

  validation {
    condition     = can(regex("^[0-9A-Za-z][A-Za-z0-9\\-_]+$", var.tenant))
    error_message = "The 'tenant' variable must meet these regex \"^[0-9A-Za-z][A-Za-z0-9\\-_]+$\" requirements."
  }

}

variable "environment" {
  type        = string
  description = "Environment area, e.g. prod or preprod"

  validation {
    condition     = can(regex("^[0-9A-Za-z][A-Za-z0-9\\-_]+$", var.environment))
    error_message = "The 'environment' variable must meet these regex \"^[0-9A-Za-z][A-Za-z0-9\\-_]+$\" requirements."
  }

}

variable "zone" {
  type        = string
  description = "zone, e.g. dev or qa or load or ops etc..."

  validation {
    condition     = can(regex("^[0-9A-Za-z][A-Za-z0-9\\-_]+$", var.zone))
    error_message = "The 'zone' variable must meet these regex \"^[0-9A-Za-z][A-Za-z0-9\\-_]+$\" requirements."
  }

}

variable "managed_node_groups" {
  type        = any
  description = "A map of Managed node group(s)"
}

variable "cluster_kms_key_additional_admin_arns" {
  type = list(string)
  description = "A list of additional IAM ARNs that should have FULL access (kms:*) in the KMS key policy."
  default = []
}

variable "tags" {
  type        = map(string)
  description = "default tags"
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth ConfigMap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

#-------------------------------
# TEAMS (Soft Multi-tenancy)
#-------------------------------
variable "application_teams" {
  description = "Map of maps of Application Teams to create"
  type        = any
  default     = {}
}

variable "platform_teams" {
  description = "Map of maps of platform teams to create"
  type        = any
  default     = {}
}
