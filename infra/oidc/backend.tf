terraform {
  backend "s3" {
    bucket       = "gatus-terraform-state-pincher90"
    key          = "oidc/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
