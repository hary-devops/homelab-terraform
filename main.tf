resource "tfe_workspace" "argocd" {
  name              = "argocd"
  organization      = "homelabhary"
  working_directory = "environment/argocd"
}
