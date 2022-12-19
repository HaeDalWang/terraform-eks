provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

locals {
  prometheus_charts_url = "https://prometheus-community.github.io/helm-charts"
}

## 오퍼레이터 및 변수 사용 설치
resource "helm_release" "prometheus-stack" {
  repository       = local.prometheus_charts_url
  chart            = "kube-prometheus-stack"
  name             = "monitoring"
  namespace        = var.monitoring_namespace
  version          = "42.3.0"
  create_namespace = true
  cleanup_on_fail  = true
  force_update     = false
  values = [
    "${file("values.yaml")}"
  ]
}