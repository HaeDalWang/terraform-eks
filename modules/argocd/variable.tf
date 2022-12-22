variable "host" {
  description = "argocd doaminname host"
  default     = "argocd.example.com"
  type        = string
}
variable "namespace" {
  description = "argocd namespace"
  default     = "argocd"
  type        = string
}
variable "argocd_password" {  
  description = "Argocd server init Password"
  default = "test123"
  type = string
}