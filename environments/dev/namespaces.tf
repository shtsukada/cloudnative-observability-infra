resource "kubernetes_namespace" "grpc_app" {
  metadata {
    name = "grpc-app"
    labels = {
      "pod-security.kubernetes.io/enforce" = "restricted"
    }
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      "pod-security.kubernetes.io/enforce" = "restricted"
    }
  }
}

resource "kubernetes_namespace" "sealed_secrets" {
  metadata {
    name = "sealed-secrets"
    labels = {
      "pod-security.kubernetes.io/enforce" = "restricted"
    }
  }
}
