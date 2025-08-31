resource "helm_release" "sealed_secrets" {
  name = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart = "sealed-secrets"
  version = var.sealed_secrets_chart_version

  namespace = kubernetes_namespace.sealed_secrets.metadata[0].name
  create_namespace = false

  wait = true
  atomic = true
  cleanup_on_fail = true
  timeout = 600
}
