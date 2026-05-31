data "tfe_organization" "homelabhary" {
  name = "harysetiawan23"
}

resource "tfe_project" "homelab_aws_base" {
  name         = "homelab-aws-base"
  organization = data.tfe_organization.homelabhary.name
}

data "tfe_github_app_installation" "gha" {
  installation_id = var.github_app_installation_id
}

resource "tfe_workspace" "homelab_aws_base" {
  name         = "homelab-aws-base"
  organization = data.tfe_organization.homelabhary.name
  project_id   = tfe_project.homelab_aws_base.id
  vcs_repo {
    github_app_installation_id = data.tfe_github_app_installation.gha.id
    identifier                 = "hary-devops/homelab-terraform"
    branch                     = "main"
  }
}
