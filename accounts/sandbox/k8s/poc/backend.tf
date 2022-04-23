terraform {
  backend "local" {
    path = "./__local_tf_state/terraform.tfstate"
  }

  /*backend "s3" {
    bucket         = "terraform-state"
    key            = "infrastructure/accounts/sandbox/k8s/poc.tfstate"
    profile        = "sandbox"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state"
  }*/
}
