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
    name ="cr.spec.external_service.grafana.auth.password"
    value = var.grafana_password
  }
  set {
    name ="cr.spec.external_service.prometheus.url"
    value = var.prometheus_url
  }

}

# # Kiali 커스텀리소스를 이용하여 배포
# resource "kubernetes_manifest" "kiali_kiali" {
#   manifest = {
#     "apiVersion" = "kiali.io/v1alpha1"
#     "kind"       = "Kiali"
#     "metadata" = {
#       "name" = "kiali"
#       "namespace" = var.istio_ns
#     }
#     "spec" = {
#       "deployment" = {
#         "accessible_namespaces" = ["**"]
#         "ingress" = {
#           "class_name" = "alb"
#           "enabled"    = true
#           "override_yaml" = {
#             "metadata" = {
#               "annotations" = {
#                 "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"
#                 "alb.ingress.kubernetes.io/group.name"       = "monitoring-alb-group"
#                 "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
#                 "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
#                 "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
#                 "alb.ingress.kubernetes.io/target-type"      = "ip"
#               }
#             }
#             "spec" = {
#               "rules" = [
#                 {
#                   "host" = var.host
#                   "http" = {
#                     "paths" = [
#                       {
#                         "backend" = {
#                           "service" = {
#                             "name" = "kiali"
#                             "port" = {
#                               "number" = 20001
#                             }
#                           }
#                         }
#                         "path"     = "/"
#                         "pathType" = "Prefix"
#                       },
#                     ]
#                   }
#                 },
#               ]
#             }
#           }
#         }
#         "namespace"      = var.istio_ns
#         "view_only_mode" = false
#       }
#       "external_services" = {
#         "custom_dashboards" = {
#           "enabled" = true
#           "is_core" = false
#           "prometheus" = {
#             "cache_duration"   = 10
#             "cache_enabled"    = true
#             "cache_expiration" = 300
#             "url"              = var.prometheus_url
#           }
#         }
#         "grafana" = {
#           "auth" = {
#             "in_cluster_url"       = var.grafana_url
#             "insecure_skip_verify" = false
#             "is_core"              = false
#             "password"             = var.grafana_password
#             "type"                 = "basic"
#             "url"                  = var.grafana_url
#             "username"             = "admin"
#           }
#         }
#         "prometheus" = {
#           "url" = var.prometheus_url
#         }
#       }
#       "installation_tag" = "Custom"
#       "istio_namespace"  = var.istio_ns
#       "server" = {
#         "web_root" = "/"
#       }
#     }
#   }
# }