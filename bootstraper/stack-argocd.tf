# Terraform stack using github.com as VCS
resource "spacelift_stack" "argocd" {
  administrative    = false
  autodeploy        = true
  branch            = "main"
  description       = "Manage argocd"
  name              = "argocd"
  project_root      = "environment/argocd"
  repository        = "homelab-terraform"
  terraform_version = "1.3.0"
  space_id          = "root"
  worker_pool_id    = "01JM7DZSZR0AZB8X5ZFD97W8KZ"
}


resource "spacelift_environment_variable" "argocd-kubeconfig" {
  stack_id    = spacelift_stack.argocd.id
  name        = "TF_VAR_argocd_kubeconfig"
  write_only  = false
  description = "argocd Kubeconfig Path"
  value       = "~/.kube/homelab_config.yaml"
}


resource "spacelift_environment_variable" "argocd-kubecontext" {
  stack_id    = spacelift_stack.argocd.id
  name        = "TF_VAR_argocd_kubecontext"
  write_only  = false
  description = "argocd Kubecontext"
  value       = "local"
}
