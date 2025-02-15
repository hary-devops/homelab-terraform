# Terraform stack using github.com as VCS
resource "spacelift_stack" "harvester" {
  administrative    = false
  autodeploy        = true
  branch            = "main"
  description       = "Manage Harvester"
  name              = "Authentik"
  project_root      = "environment/authentik"
  repository        = "homelab-terraform"
  terraform_version = "1.3.0"
  space_id          = "root"
}


resource "spacelift_environment_variable" "harvester-kubeconfig" {
  stack_id    = spacelift_stack.authentik.id
  name        = "TF_VAR_harvester_kubeconfig"
  write_only  = false
  description = "Harvester Kubeconfig Path"
}


resource "spacelift_environment_variable" "harvester-kubecontext" {
  stack_id    = spacelift_stack.authentik.id
  name        = "TF_VAR_harvester_kubecontext"
  write_only  = false
  description = "Harvester Kubecontext"
}
