## Istio install Namespace
variable "namespace" {
  description = "istio namespace"
  type        = string
  default     = "istio-system"
}

## ALB istio DomainName 
variable "gateway-host" {
  description = "expose alb host"
  type        = string
  default     = "www.example.com"
}

## istio gateway service resource Name
variable "gateway-service" {
  description = "istio-gateway service resource name"
  type        = string
  default     = "istio-ingress-gateway"
}