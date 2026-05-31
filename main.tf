data "tfe_organization" "homelabhary" {
  name = "harysetiawan23"
}

data "tfe_project" "homelab_aws_base" {
  name         = "homelab"
  organization = data.tfe_organization.homelabhary.id
}

resource "tfe_workspace" "homelab_aws_base" {
  name         = "homelab-aws-base"
  organization = data.tfe_organization.homelabhary.name
  project_id   = data.tfe_organization.homelabhary.id
}
