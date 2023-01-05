locals {
  kiali_charts_url = "https://kiali.org/helm-charts"
}

## Kiali 서버 배포(standalone)
resource "helm_release" "kiali" {
  repository       = local.kiali_charts_url
  chart            = "kiali-server"
  name             = "kiali-server"
  namespace        = var.istio_ns
  version          = var.kiali_version
  force_update     = false
  values = [
    "${file("./helm_values/kiali-server.yaml")}",
  ]
  set {
    name ="external_services.grafana.url"
    value = var.grafana_url
  }
  set {
    name ="external_services.grafana.health_check_url"
    value = "${var.grafana_url}/api/health"
  }
  set {
    name ="external_services.grafana.auth.password"
    value = var.grafana_password
  }
  set {
    name ="external_services.prometheus.url"
    value = var.prometheus_url
  }
  set {
    name ="server.web_fqdn"
    value = var.host
  }
}


## 오퍼레이터 및 kiali 배포
## 이슈: destory시 cr 전 오퍼레이터를 선행 삭제하여 cr 삭제에서 멈춤
# resource "helm_release" "kiali-operator" {
#   repository       = local.kiali_charts_url
#   chart            = "kiali-operator"
#   name             = "kiali-operator"
#   namespace        = kubernetes_namespace.kiali.metadata[0].name
#   version          = var.kiali_version
#   cleanup_on_fail  = true
#   force_update     = false
#   values = [
#     "${file("./helm_values/kiali-operator.yaml")}",
#   ]
#   set {
#     name ="cr.namespace"
#     value = kubernetes_namespace.kiali.metadata[0].name
#   }
#   set {
#     name ="cr.spec.external_service.custom_dashboards.prometheus.url"
#     value = var.prometheus_url
#   }
#   set {
#     name ="cr.spec.external_service.grafana.url"
#     value = var.grafana_url
#   }
#   set {
#     name ="cr.spec.external_service.grafana.in_cluster_url"
#     value = var.grafana_url
#   }
#   set {
#     name ="cr.spec.external_service.grafana.auth.password"
#     value = var.grafana_password
#   }
#   set {
#     name ="cr.spec.external_service.prometheus.url"
#     value = var.prometheus_url
#   }
#   set {
#     name ="cr.spec.deployment.ingress.override_yaml.spec.rules[0].host"
#     value = var.host
#   }
# }