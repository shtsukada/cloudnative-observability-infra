locals {
  default_source_repos = ["https://github.com/${var.repo_owner}/*"]
  source_repos         = length(var.source_repos_allowlist) > 0 ? var.source_repos_allowlist : local.default_source_repos
}

resource "kubernetes_manifest" "argocd_project_cno" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AppProject"
    metadata = {
      name      = "cloudnative-observability"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      labels = {
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }
    spec = {
      description = "Guardrails for cloudnative-observability portfolio"
      sourceRepos = local.source_repos

      destinations = [
        for ns in var.allowed_namespaces : {
          namespace = ns
          server    = "https://kubernetes.default.svc"
        }
      ]
      clusterResourceWhitelist = [
        { group = "*", kind = "*" }
      ]
      orphanedResources = {
        warn = true
      }
    }
  }
  depends_on = [
    helm_release.argocd,
  ]
}

resource "kubernetes_manifest" "argocd_app_root" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "cloudnative-observability-root"
      namespace = kubernetes_namespace.argocd.metadata[0].name
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
      labels = {
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }
    spec = {
      project = kubernetes_manifest.argocd_project_cno.manifest.metadata.name

      source = {
        repoURL        = var.root_repo_url
        targetRevision = var.root_repo_revision
        path           = "apps"
        directory = {
          recurse = true
        }
      }

      destinations = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }

      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true",
          "ApplyOutOfSyncOnly=true"
        ]
      }
    }
  }
  depends_on = [
    helm_release.argocd,
    kubernetes_manifest.argocd_project_cno,
  ]
}
