locals {
  argocd_charts_url = "https://argoproj.github.io/argo-helm"
}

## ArgoCD helm install
resource "helm_release" "argocd" {
  repository       = local.argocd_charts_url
  chart            = "argo-cd"
  name             = "argocd"
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = true
  cleanup_on_fail  = true
  force_update     = false
  values = [
    "${file("./modules/argocd/values.yaml")}",
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