resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.demo_aks_cluster]
  filename   = "kubeconfig"
  content    = azurerm_kubernetes_cluster.demo_aks_cluster.kube_config_raw
}

output "api_external_ip" {
  value = kubernetes_service.demo_api_lb_svc.status.0.load_balancer.0.ingress.0.ip
}

output "webapp_external_ip" {
  value = kubernetes_service.demo_webapp_lb_svc.status.0.load_balancer.0.ingress.0.ip
}
