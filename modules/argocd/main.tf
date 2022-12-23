locals {
  argocd_charts_url = "https://argoproj.github.io/argo-helm"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

## ArgoCD helm install
resource "helm_release" "argocd" {
  repository       = local.argocd_charts_url
  chart            = "argo-cd"
  name             = "argocd"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  version          = var.chart_version
  create_namespace = true
  cleanup_on_fail  = true
  force_update     = false
  values = [
    "${file("./helm_values/argocd.yaml")}",
  ]
  set {
    name  = "server.ingress.hosts[0]"
    value = var.host
  }
  set {
    name = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_password
  }
}