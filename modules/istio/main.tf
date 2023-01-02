terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

resource "kubernetes_namespace" "istio" {
  metadata {
    name = var.namespace
  }
}

## CRD
resource "helm_release" "istio-base" {
  repository       = local.istio_charts_url
  chart            = "base"
  name             = "istio-base"
  namespace        = kubernetes_namespace.istio.metadata[0].name
  version          = var.istio_version
  cleanup_on_fail  = true
  force_update     = false
}

## Istio istiod component deploy
resource "helm_release" "istiod" {
  repository       = local.istio_charts_url
  chart            = "istiod"
  name             = "istiod"
  namespace        = kubernetes_namespace.istio.metadata[0].name
  version          = var.istio_version
  depends_on       = [helm_release.istio-base]
  cleanup_on_fail  = true
  force_update     = false
}

## ALB와 함께 istio-controller을 사용하고 싶을 경우 주석을 풀고 사용하세요
# ## Istio Gateway deployment
# resource "helm_release" "istio-gateway" {
#   repository      = local.istio_charts_url
#   chart           = "gateway"
#   name            = "istio-ingress"
#   namespace       = kubernetes_namespace.istio.metadata[0].name
#   version         = var.istio_version
#   depends_on      = [helm_release.istiod]
#   cleanup_on_fail = true
#   force_update    = false
#   ## ALB와 연결을 위해 nodeport로 지정
#   set {
#     name  = "service.type"
#     value = "NodePort"
#   }
#   set {
#     name  = "name"
#     value = var.gateway-service
#   }
# }

# ## kubernetes ingerss alb (istio ingress)
# resource "kubernetes_ingress_v1" "istio-ingress" {
#   depends_on = [helm_release.istio-gateway]
#   metadata {
#     name      = "istio-ingress-gateway"
#     namespace = var.namespace
#     annotations = {
#       "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
#       "alb.ingress.kubernetes.io/target-type"          = "ip"
#       "alb.ingress.kubernetes.io/backend-protocol"     = "HTTP"
#       "alb.ingress.kubernetes.io/healthcheck-path"     = "/healthz/ready"
#       "alb.ingress.kubernetes.io/healthcheck-port"     = "traffic-port"
#       "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
#       "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTP\": 80},{\"HTTPS\":443}]"
#       "alb.ingress.kubernetes.io/ssl-redirect"         = "443"
#     }
#   }
#   spec {
#     ingress_class_name = "alb"
#     rule {
#       host = var.gateway-host
#       http {
#         path {
#           backend {
#             service {
#               name = var.gateway-service
#               port {
#                 number = 15021
#               }
#             }
#           }
#           path = "/healthz/ready/*"
#         }
#         path {
#           backend {
#             service {
#               name = var.gateway-service
#               port {
#                 number = 80
#               }
#             }
#           }
#           path = "/*"
#         }
#       }
#     }
#   }
# }

# Istiod PodMonitor 및 ServiceMonitor 설정파일 다운로드
data "http" "istio_monitor" {
  url = "https://raw.githubusercontent.com/istio/istio/master/samples/addons/extras/prometheus-operator.yaml"
}
data "kubectl_file_documents" "istio_monitor" {
  content = data.http.istio_monitor.response_body
}

# Istiod와 사이드카 프록시에서 지표가 수집되도록 설정
resource "kubectl_manifest" "istio_monitor" {
  for_each  = data.kubectl_file_documents.istio_monitor.manifests
  yaml_body = each.value

  depends_on = [
    helm_release.istiod
  ]
}