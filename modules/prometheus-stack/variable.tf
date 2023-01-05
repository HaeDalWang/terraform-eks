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

variable "prometheus_host" {
  description = "Prometheus Host name"
  default = "prometheus.example.com"
  type = string  
}

variable "grafana_host" {
  description = "grafana Host name"
  default = "grafana.example.com"
  type = string  
}

variable "alertmanager_host" {
  description = "alertmanager Host name"
  default = "alertmanager.example.com"
  type = string  
}
