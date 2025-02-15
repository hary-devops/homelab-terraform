# Terraform stack using github.com as VCS
resource "spacelift_stack" "authentik" {
  administrative    = false
  autodeploy        = true
  branch            = "master"
  description       = "Provision Authentik"
  name              = "Authentik"
  project_root      = "environemnt/authentik"
  repository        = var.repository
  terraform_version = "1.3.0"
  space_id          = "root"
}


resource "spacelift_environment_variable" "authentik-token" {
  stack_id    = spacelift_stack.authentik.space_id
  name        = "AUTHENTIK_TOKEN"
  write_only  = false
  description = "Authentik Token"
}
