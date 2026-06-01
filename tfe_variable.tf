resource "tfe_variable" "github_app_installation_id" {
  key          = "github_app_installation_id"
  value        = var.github_app_installation_id
  category     = "terraform"
  workspace_id = tfe_workspace.homelab_aws_base.id
}