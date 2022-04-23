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

variable "terraform_version" {
  type        = string
  description = "The version of terraform used (e.g. Terraform v1.1.9)"
}

variable "tf_state_eks_local_state_path" {
  type        = string
  description = "Relative path to the EKS Terraform state"
}

/*variable "tf_state_eks_s3_bucket" {
  type        = string
  description = "S3 bucket name for EKS Terraform state"
}

variable "tf_state_eks_s3_key" {
  type        = string
  description = "S3 bucket key name for EKS Terraform state"
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

variable "tags" {
  type        = map(string)
  description = "default tags"
}
