resource "tfe_workspace" "argocd" {
  name              = "argocd"
  organization      = "homelab"
  working_directory = "environment/argocd"
}
