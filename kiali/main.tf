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

## 오퍼레이터 배포
resource "helm_release" "kiali-operator" {
  repository       = local.kiali_charts_url
  chart            = "kiali-operator"
  name             = "kiali-operator"
  namespace        = var.kiali_operator_namespace
  version          = "1.60.0"
  create_namespace = true
  cleanup_on_fail  = true
  force_update     = false
}

# Kiali 커스텀리소스를 이용하여 배포
# data "local_file" "kiali-cr" {
#   filename = "./kiali-cr.yaml"
# }
# resource "kubernetes_manifest" "kiali-core" {
#     manifest = data.local_file.kiali-cr
# }