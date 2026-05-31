terraform {
  cloud {
    organization = "harysetiawan23"

    workspaces {
      name = "homelab-terraform"
    }
  }

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.77.0"
    }
  }
}

provider "tfe" {
  hostname = "app.terraform.io"
  # Token will be read from TFE_TOKEN environment variable
  # Set this in Terraform Cloud workspace as an environment variable
}
