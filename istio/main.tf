provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}

locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

## CRD & namesapce 
resource "helm_release" "istio-base" {
  repository       = local.istio_charts_url
  chart            = "base"
  name             = "istio-base"
  namespace        = var.istio-namespace
  version          = "1.16.1"
  create_namespace = true
  cleanup_on_fail  = true
  force_update     = false
}

## Istio istiod component deploy
resource "helm_release" "istiod" {
  repository       = local.istio_charts_url
  chart            = "istiod"
  name             = "istiod"
  namespace        = var.istio-namespace
  create_namespace = true
  version          = "1.16.1"
  depends_on       = [helm_release.istio-base]
  cleanup_on_fail  = true
  force_update     = false
}

## Istio Gateway deployment
resource "helm_release" "istio-gateway" {
  repository      = local.istio_charts_url
  chart           = "gateway"
  name            = "istio-ingress"
  namespace       = var.istio-namespace
  version         = "1.16.1"
  depends_on      = [helm_release.istiod]
  cleanup_on_fail = true
  force_update    = false
  set {
    name  = "service.type"
    value = "NodePort"
  }
  set {
    name  = "name"
    value = var.istio-gateway-service
  }
}

## kubernetes ingerss alb (istio ingress)
resource "kubernetes_ingress_v1" "istio-ingress" {
  depends_on = [helm_release.istio-gateway]
  metadata {
    name      = "istio-ingress-gateway"
    namespace = var.istio-namespace
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
      host = var.istio-host
      http {
        path {
          backend {
            service {
              name = var.istio-gateway-service
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
              name = var.istio-gateway-service
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