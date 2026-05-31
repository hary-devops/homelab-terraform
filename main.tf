resource "tfe_project" "homelab_aws" {
  name         = "homelab-aws"
  organization = "homelabhary"
}

resource "tfe_workspace" "homelab_aws_base" {
  name         = "homelab-aws-base"
  organization = "homelabhary"
  project_id = tfe_project.homelab_aws.id
}