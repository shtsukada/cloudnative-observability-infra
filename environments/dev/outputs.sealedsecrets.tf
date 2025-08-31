data "kubernetes_secret" "sealed_secrets_key" {
  metadata {
    name = "sealed-secrets-key"
    namespace = kubernetes_namespace.sealed_secrets.metadata[0].name
  }
  depends_on = [helm_release.sealed_secrets]
}

locals {
  sealed_secrets_public_cert_pem = base64decode(lookup(data.kubernetes_secret.sealed_secrets_key.data, "tls.crt", ""))
}

output "sealed_secrets_public_cert_pem" {
  description = "Public certificate (PEM) for kubeseal --cert"
  value = local.sealed_secrets_public_cert_pem
}
