resource "tfe_project" "homelab_db" {
  name         = "homelab_db"
  organization = "homelabhary"
}

resource "tfe_workspace" "argocd" {
  name              = "argocd"
  organization      = "homelabhary"
  working_directory = "environment/db"
  project_id        = tfe_project.homelab_db.id
}
