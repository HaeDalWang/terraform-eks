########## Kube app Modules ##########

module "prometheus-stack" {
  source = "./modules/prometheus-stack/"

  namespace        = "monitoring"
  chart_version    = "42.3.0"
  grafana_password = "test123"
}

module "istio" {
  source = "./modules/istio/"

  namespace     = "istio-system"
  istio_version = "1.16.0"
  # Istio-ingress-Controller 사용시 해제 하세요
  # gateway-host  = "istio.51bsd.click"
}

module "kiali" {
  source = "./modules/kiali"

  kiali_version    = "1.60.0"
  host             = "kiali.51bsd.click"
  prometheus_url   = module.prometheus-stack.prometheus_url
  grafana_url      = module.prometheus-stack.grafana_url
  grafana_password = module.prometheus-stack.grafana_password
  istio_ns         = module.istio.istio_namespace

  depends_on = [
    module.prometheus-stack,
    moduel.istio
  ]
}

# module "argocd" {
#   source = "./modules/argocd"

#   chart_version   = "5.16.9"
#   host            = "argocd.51bsd.click"
#   argocd_password = "test123"
# }

# ## AWS Opensearch + Fluent-bit
# module "logging" {
#   source = "./modules/opensearch_fluent-bit"

#   domain_name   = "test_domain"
#   versino       = "OpenSearch_2.3"
#   instance_type = "r6.large.search"
# }