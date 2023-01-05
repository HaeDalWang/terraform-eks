output "namespace" {
  description = "Prometheus stack namesapce"
  value = helm_release.prometheus-stack.namespace
}

output "prometheus_url" {
  description = "incluster prometheus URL"
  value = "http://kube-prometheus-prometheus.${helm_release.prometheus-stack.namespace}.svc.cluster.local:9090"
}

output "grafana_url" {
  description = "grafana URL"
  value = "https://${var.grafana_host}"
}

output "grafana_password" {
  description = "grafana password"
  value= var.grafana_password
}