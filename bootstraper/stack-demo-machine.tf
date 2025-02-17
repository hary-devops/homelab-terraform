# Terraform stack using github.com as VCS
resource "spacelift_stack" "demo-machine" {
  administrative    = false
  autodeploy        = true
  branch            = "main"
  description       = "Manage Demo Machine"
  name              = "Demo Machine"
  project_root      = "environment/demo-machine"
  repository        = "homelab-terraform"
  terraform_version = "1.3.0"
  space_id          = "root"
}


resource "spacelift_environment_variable" "demo-machine-kubeconfig" {
  stack_id    = spacelift_stack.demo-machine.id
  name        = "TF_VAR_harvester_kubeconfig"
  write_only  = false
  description = "Harvester Kubeconfig Path"
}


resource "spacelift_environment_variable" "demo-machine-kubecontext" {
  stack_id    = spacelift_stack.demo-machine.id
  name        = "TF_VAR_harvester_kubecontext"
  write_only  = false
  description = "Harvester Kubecontext"
}
