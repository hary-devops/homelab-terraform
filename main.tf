resource "tfe_workspace" "argocd" {
  name         = "argocd"
  organization = "homelab"

  working_directory = "environment/argocd"

  vcs_repo {
    identifier         = "harysetiawan/homelab-terraform"
    branch             = "main"
    ingress_submodules = true
  }
}
