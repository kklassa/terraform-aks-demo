variable "dns_prefix" {
  type    = string
  default = "terraform-aks-demo"
}

variable "kubernetes_version" {
  type    = string
  default = "1.25.2"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "namespace" {
  type    = string
  default = "demo"
}

variable "api_image" {
  type    = string
  default = "quay.io/kklassa/k8s-demo-api:latest"
}

variable "api_replicas" {
  type    = number
  default = 1
}

variable "webapp_image" {
  type    = string
  default = "quay.io/kklassa/k8s-demo-webapp:latest"
}

variable "webapp_replicas" {
  type    = number
  default = 1
}
