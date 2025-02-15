
resource "helm_release" "atlantis" {
  repository       = "https://runatlantis.github.io/helm-charts"
  chart            = "atlantis"
  create_namespace = true
  name             = "atlantis"
  values           = [file("./values.yaml")]
}
