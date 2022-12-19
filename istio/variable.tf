## Istio install Namespace
variable "istio-namespace" {
  description = "istio namespace"
  type        = string
  default     = "istio-system"
}

## ALB istio DomainName 
variable "istio-host" {
  description = "expose alb host"
  type        = string
  default     = "istio.51bsd.click"
}

## istio gateway service resource Name
variable "istio-gateway-service" {
  description = "istio-gateway service resource name"
  type        = string
  default     = "istio-ingress-gateway"
}