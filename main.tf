resource "tfe_project" "homelab_db" {
  name         = "homelab_db"
  organization = "homelabhary"
}

resource "tfe_workspace" "homelab_db" {
  name              = "homelab_db"
  organization      = "homelabhary"
  working_directory = "environment/db"
  project_id        = tfe_project.homelab_db.id

  vcs_repo {
    identifier                 = "hary-devops/homelab-terraform"
    branch                     = "main"
    github_app_installation_id = var.github_app_installation_id
  }

  # Enable Sentinel policy checks (Terraform Cloud Plus/Enterprise)
  # For open-source alternative, use OPA or run Checkov in CI/CD
}

# Policy set for security and compliance checks
resource "tfe_policy_set" "homelab_security" {
  name         = "homelab-security-policies"
  description  = "Security and compliance policies for homelab infrastructure"
  organization = "homelabhary"
  kind         = "sentinel" # or "opa" for Open Policy Agent

  # Attach to workspace
  workspace_ids = [tfe_workspace.homelab_db.id]
}

# For Checkov integration, add this to your workspace
resource "tfe_workspace_settings" "homelab_db_settings" {
  workspace_id   = tfe_workspace.homelab_db.id
  execution_mode = "agent"
  agent_pool_id  = var.agent_pool_id
}

# Run task for external policy checking (like Checkov)
# This requires Terraform Cloud Plus or Enterprise
resource "tfe_organization_run_task" "checkov" {
  organization = "homelabhary"
  url          = var.checkov_run_task_url
  name         = "checkov-security-scan"
  enabled      = true
  description  = "Checkov security and compliance scanning"
  hmac_key     = var.checkov_hmac_key
}

resource "tfe_workspace_run_task" "homelab_db_checkov" {
  workspace_id      = tfe_workspace.homelab_db.id
  task_id           = tfe_organization_run_task.checkov.id
  enforcement_level = "advisory"   # Can be "advisory" or "mandatory"
  stages            = ["pre_plan"] # Run before plan
}
