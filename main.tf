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

  # Checkov security scanning runs automatically via GitHub Actions
  # See .github/workflows/checkov.yml for configuration
}

resource "tfe_project" "homelab_gcp" {
  name         = "homelab_gcp"
  organization = "homelabhary"
}

resource "tfe_workspace" "homelab_gcp" {
  name              = "homelab_gcp"
  organization      = "homelabhary"
  working_directory = "environment/gcp"
  project_id        = tfe_project.homelab_gcp.id
  vcs_repo {
    identifier                 = "hary-devops/homelab-terraform"
    branch                     = "main"
    github_app_installation_id = var.github_app_installation_id
  }
  
  # Checkov security scanning runs automatically via GitHub Actions
  # See .github/workflows/checkov.yml for configuration
}


