terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}

provider "helm" {
  # Configuration options
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "terrakube"
  }
}
