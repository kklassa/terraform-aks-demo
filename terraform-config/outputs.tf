resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.demo_aks_cluster]
  filename   = "kubeconfig"
  content    = azurerm_kubernetes_cluster.demo_aks_cluster.kube_config_raw
}
