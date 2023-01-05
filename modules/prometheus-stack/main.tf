locals {
  prometheus_charts_url = "https://prometheus-community.github.io/helm-charts"
}

resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = var.namespace
  }
}

## 오퍼레이터 및 변수 사용 설치
resource "helm_release" "prometheus-stack" {
  repository       = local.prometheus_charts_url
  chart            = "kube-prometheus-stack"
  name             = "monitoring"
  namespace        = kubernetes_namespace.prometheus.metadata[0].name
  version          = var.chart_version
  cleanup_on_fail  = true
  force_update     = false
  values = [
    "${file("./helm_values/prometheus-stack-minimal.yaml")}",
  ]
  set {
    name = "grafana.adminPassword"
    value = var.grafana_password
  }
  set {
    name = "prometheus.ingress.hosts[0]"
    value = var.prometheus_host
  }
  set {
    name = "grafana.ingress.hosts[0]"
    value = var.grafana_host
  }
  set {
    name = "alertmanager.ingress.hosts[0]"
    value = var.alertmanager_host
  }
}