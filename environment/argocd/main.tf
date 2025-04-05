resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd"
  version    = "5.24.1"

  create_namespace = true

  values = [
    file("./values.yaml")
  ]
}
