variable "istio_ns" {
  description = "istio root ns"
  type        = string
  default = "istio-system"
}

variable "prometheus_url" {
  description = "incluster Prometheus URL"
  type        = string
  default = ""
}

variable "grafana_url" {
  description = "incluster Grafana URL"
  type        = string
  default = ""
}

variable "grafana_password" {
  description = "Grafana Connection Password"
  type        = string
  default = ""
}

variable "host" {
  description = "kiali domain host"
  type        = string
  default     = "kiali.example.com"
}