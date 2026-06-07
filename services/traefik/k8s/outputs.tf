output "traefik_dashboard_url" {
  value = "https://${var.dashboard_domain}"
}

output "traefik_lb_ip" {
  value = kubernetes_service.traefik.status[0].load_balancer[0].ingress[0].ip
}
