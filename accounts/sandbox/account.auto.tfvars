aws_region                    = "us-west-2"
environment                   = "sbox"
org                           = "examplecorp"
// Tenant can not contain periods
tenant                        = "the-a-team"
terraform_version             = "Terraform v1.1.9"
tf_state_vpc_local_state_path = "../../network/primary/__local_tf_state/terraform.tfstate"
//tf_state_vpc_s3_bucket        = "terraform-state"
//tf_state_vpc_s3_key           = "infrastructure/accounts/sandbox/network/primary.tfstate"

tags = {
  architecture = "terraform"
  domain       = "platform"
  env          = "sandbox"
  owner        = "the-a-team"
  email        = "the-a-team@example.com"
}
