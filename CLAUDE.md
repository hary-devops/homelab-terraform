# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This repo is a **meta-Terraform configuration**: the root module uses the `tfe` provider to provision Terraform Cloud (HCP Terraform) projects and workspaces, which in turn execute the child modules under `environment/`. The org is `homelabhary` and the VCS-connected repo is `hary-devops/homelab-terraform`.

Two independent environments, each backed by its own TFC workspace:

- **`environment/gcp`** — workspace `homelab_gcp`. Provisions a GCP VM (e2-medium), custom VPC/subnet/firewall, and a full Cloud Monitoring stack (notification channel + alert policies in `monitoring.tf`). Required GCP APIs are enabled via `apis.tf`; downstream resources use `depends_on` on those `google_project_service` resources so an initial apply does not race API activation. Authenticated via `GOOGLE_CREDENTIALS` set as a sensitive env var on the TFC workspace.
- **`environment/db`** — workspace `homelab_db`. Uses the `kreuzwerker/docker` provider against a Docker host (currently `unix:///var/run/docker.sock`, so the TFC run agent must execute on the Docker host itself). The `docker_host_user` / `docker_host_ip` root variables exist for future SSH-based wiring.

The root module (`main.tf`, `provider.tf`, `variables.tf`) is itself applied from a separate TFC workspace and only manages TFC objects — never directly manages GCP/Docker resources. `policy_tasks.tf.example` is a commented template for TFC Plus/Enterprise run tasks; do not rename it to `.tf` unless the org has the required tier.

## Common commands

Each Terraform module is run from its own directory:

```bash
# Root (manages TFC workspaces themselves — rarely needs local runs since it's also a TFC workspace)
terraform -chdir=. init && terraform -chdir=. plan

# GCP environment
cd environment/gcp && terraform init && terraform plan && terraform apply

# Docker/DB environment
cd environment/db && terraform init && terraform plan && terraform apply
```

For the GCP module locally, authenticate first with `gcloud auth application-default login` or `export GOOGLE_APPLICATION_CREDENTIALS=...`. In TFC, credentials are injected as the `GOOGLE_CREDENTIALS` workspace env var.

## CI / security scanning

`.github/workflows/checkov.yml` runs Checkov on every push/PR to `main` against the entire repo (`framework: terraform`). It is `soft_fail: true` — results upload to GitHub code scanning but never block the merge. Jobs run on the self-hosted `homelab` runner. Native TFC run tasks for Checkov are intentionally disabled (see `policy_tasks.tf.example`).

## Conventions and gotchas

- Default region/zone is **Jakarta** (`asia-southeast2` / `asia-southeast2-a`); Singapore (`asia-southeast1`) is the documented alternative.
- The GCP VM's SSH firewall rule is open to `0.0.0.0/0` and the VM gets an ephemeral public IP — keep this in mind before adding services beyond SSH.
- Cloud Ops Agent is installed via `metadata_startup_script`; alert policies in `monitoring.tf` filter on `google_compute_instance.vm_instance.instance_id`, so renaming/recreating the VM invalidates existing alert state.
- `disable_on_destroy = false` on all `google_project_service` resources — destroying the module will not turn APIs back off.
