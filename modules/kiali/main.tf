provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}

locals {
  kiali_charts_url = "https://kiali.org/helm-charts"
}

## 오퍼레이터 및 kiali 배포
resource "helm_release" "kiali-operator" {
  repository       = local.kiali_charts_url
  chart            = "kiali-operator"
  name             = "kiali-operator"
  namespace        = var.namespace
  version          = var.kiali_version
  create_namespace = true
  cleanup_on_fail  = true
  force_update     = false
  values = [
    "${file("./modules/kiali/kiali-helm-value.yaml")}",
  ]
  set {
    name ="cr.namespace"
    value = var.istio_ns
  }
  set {
    name ="cr.spec.external_service.custom_dashboards.prometheus.url"
    value = var.prometheus_url
  }
  set {
    name ="cr.spec.external_service.grafana.url"
    value = var.grafana_url
  }
  set {
    name ="cr.spec.external_service.grafana.in_cluster_url"
    value = var.grafana_url
  }
  set {
    name ="cr.spec.external_service.grafana.auth.password"
    value = var.grafana_password
  }
  set {
    name ="cr.spec.external_service.prometheus.url"
    value = var.prometheus_url
  }
  set {
    name ="cr.spec.deployment.ingress.override_yaml.spec.rules[0].host"
    value = var.host
  }
}