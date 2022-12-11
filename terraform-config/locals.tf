locals {
  api_lb_ip = format("http://%s", kubernetes_service.demo_api_lb_svc.status.0.load_balancer.0.ingress.0.ip)
}
