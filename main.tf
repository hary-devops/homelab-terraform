data "tfe_organization" "homelabhary" {
  name = "homelabhary"
}

data "tfe_project" "homelab_aws_base" {
  name         = "homelab"
  organization = data.tfe_organization.homelabhary.id
}

resource "tfe_workspace" "homelab_aws_base" {
  name         = "homelab-aws-base"
  organization = tfe_organization.homelabhary.id
  project_id   = tfe_project.homelab_aws_base.id
}
