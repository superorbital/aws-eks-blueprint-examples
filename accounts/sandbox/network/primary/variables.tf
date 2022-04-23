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
