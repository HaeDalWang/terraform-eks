variable "namespace" {
    description = "Prometheus-Stack Namespace"
    default = "monitoring"
    type = string
}

variable "grafana_password" {
  description = "Grafana Pasword"
  default = "1234"
  type = string
}