resource "kubernetes_namespace" "argocd" {
  provider = kubernetes.eks
  metadata {
    name = "argocd"
    labels = {
      "pod-security.kubernetes.io/enforce" = "restricted"
    }
  }
}

resource "helm_release" "argocd" {
  provider = helm.eks
  name = "argocd"
  namespace = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  version = "8.3.0"
  create_namespace = false
  cleanup_on_fail = true
  timeout = 600

  values = [<<-YAML
    global: {}

    crds:
      install: true

    dex:
      enabled: false

    notifications:
      enabled: false

    controller:
      replicas: 1

    repoServer:
      replicas: 1

    applicationSet:
      enabled: true

    server:
      replicas: 1
      service:
        type: ClusterIP

    config:
      params:
        server.insecure: "true"
  YAML
  ]
}
output "argocd_namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_release_version" {
  value = helm_release.argocd.version
}
