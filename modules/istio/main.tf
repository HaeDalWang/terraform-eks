locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

## CRD & namesapce 
resource "helm_release" "istio-base" {
  repository       = local.istio_charts_url
  chart            = "base"
  name             = "istio-base"
  namespace        = var.namespace
  version          = var.istio_version
  create_namespace = true
  cleanup_on_fail  = true
  force_update     = false
}

## Istio istiod component deploy
resource "helm_release" "istiod" {
  repository       = local.istio_charts_url
  chart            = "istiod"
  name             = "istiod"
  namespace        = var.namespace
  create_namespace = true
  version          = var.istio_version
  depends_on       = [helm_release.istio-base]
  cleanup_on_fail  = true
  force_update     = false
}

## Istio Gateway deployment
resource "helm_release" "istio-gateway" {
  repository      = local.istio_charts_url
  chart           = "gateway"
  name            = "istio-ingress"
  namespace       = var.namespace
  version         = var.istio_version
  depends_on      = [helm_release.istiod]
  cleanup_on_fail = true
  force_update    = false
  ## ALB와 연결을 위해 nodeport로 지정
  set {
    name  = "service.type"
    value = "NodePort"
  }
  set {
    name  = "name"
    value = var.gateway-service
  }
}

## kubernetes ingerss alb (istio ingress)
resource "kubernetes_ingress_v1" "istio-ingress" {
  depends_on = [helm_release.istio-gateway]
  metadata {
    name      = "istio-ingress-gateway"
    namespace = var.namespace
    annotations = {
      "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"          = "ip"
      "alb.ingress.kubernetes.io/backend-protocol"     = "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-path"     = "/healthz/ready"
      "alb.ingress.kubernetes.io/healthcheck-port"     = "traffic-port"
      "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"
      "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTP\": 80},{\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/ssl-redirect"         = "443"
    }
  }
  spec {
    ingress_class_name = "alb"
    rule {
      host = var.gateway-host
      http {
        path {
          backend {
            service {
              name = var.gateway-service
              port {
                number = 15021
              }
            }
          }
          path = "/healthz/ready/*"
        }
        path {
          backend {
            service {
              name = var.gateway-service
              port {
                number = 80
              }
            }
          }
          path = "/*"
        }
      }
    }
  }
}

# # Istio용 PodMonitor & ServiceMonitor 매니페스트
# data "http" "monitoring_manifestfile" {
#   url = "https://raw.githubusercontent.com/istio/istio/master/samples/addons/extras/prometheus-operator.yaml"
# }
# resource "kubernetes_manifest" "monitoring_manifest" {
#   manifest = yamldecode(data.http.monitoring_manifestfile.body)
# }
