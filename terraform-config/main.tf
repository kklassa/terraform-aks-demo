resource "azurerm_resource_group" "demo_aks_group" {
  name     = "demo-aks-tf-group"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "demo_aks_cluster" {
  name                = "demo-aks-cluster"
  location            = azurerm_resource_group.demo_aks_group.location
  resource_group_name = azurerm_resource_group.demo_aks_group.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    project = "demo"
  }
}

resource "kubernetes_namespace" "demo_ns" {
  metadata {
    name = var.namespace
  }
  depends_on = [azurerm_kubernetes_cluster.demo_aks_cluster]
}

resource "kubernetes_deployment" "demo_api_deploy" {
  metadata {
    name = "api-deploy"
    labels = {
      app  = "demo"
      tier = "backend"
    }
    namespace = var.namespace
  }

  spec {
    replicas = var.api_replicas

    selector {
      match_labels = {
        app       = "demo"
        tier      = "backend"
        component = "api"
      }
    }

    template {
      metadata {
        labels = {
          app       = "demo"
          tier      = "backend"
          component = "api"
        }
      }

      spec {
        container {
          name  = "demo-api"
          image = var.api_image
          port {
            container_port = "8000"
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.demo_ns]
}

resource "kubernetes_service" "demo_api_clusterip_svc" {
  metadata {
    name      = "api-clusterip-svc"
    namespace = var.namespace
  }

  spec {
    type = "ClusterIP"

    port {
      port        = 8000
      target_port = 8000
    }

    selector = {
      app       = "demo"
      tier      = "backend"
      component = "api"
    }
  }
  depends_on = [kubernetes_deployment.demo_api_deploy]
}

resource "kubernetes_service" "demo_api_lb_svc" {
  metadata {
    name      = "api-lb-svc"
    namespace = var.namespace
  }

  spec {
    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 8000
    }

    selector = {
      app       = "demo"
      tier      = "backend"
      component = "api"
    }
  }
  depends_on = [kubernetes_deployment.demo_api_deploy]
}

resource "kubernetes_deployment" "demo_webapp_deploy" {
  metadata {
    name = "webapp-deploy"
    labels = {
      app  = "demo"
      tier = "frontend"
    }
    namespace = var.namespace
  }

  spec {
    replicas = var.webapp_replicas

    selector {
      match_labels = {
        app       = "demo"
        tier      = "frontend"
        component = "webapp"
      }
    }

    template {
      metadata {
        labels = {
          app       = "demo"
          tier      = "frontend"
          component = "webapp"
        }
      }

      spec {
        container {
          name  = "demo-webapp"
          image = var.webapp_image
          port {
            container_port = "5173"
          }
          env {
            name  = "API_URL"
            value = local.api_lb_ip
          }
        }
      }
    }
  }
  depends_on = [kubernetes_service.demo_api_lb_svc]
}

resource "kubernetes_service" "demo_webapp_lb_svc" {
  metadata {
    name      = "webapp-lb-svc"
    namespace = var.namespace
  }

  spec {
    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 5173
    }

    selector = {
      app       = "demo"
      tier      = "frontend"
      component = "webapp"
    }
  }
  depends_on = [kubernetes_deployment.demo_webapp_deploy]
}
