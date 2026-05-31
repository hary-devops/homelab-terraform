data "tfe_organization" "homelabhary" {
  name = "harysetiawan23"
}

resource "tfe_project" "homelab_aws_base" {
  name         = "homelab-aws-base"
  organization = tfe_organization.homelabhary.name
}

resource "tfe_workspace" "homelab_aws_base" {
  name         = "homelab-aws-base"
  organization = tfe_organization.homelabhary.name
  project_id   = tfe_project.homelab_aws_base.id
}
