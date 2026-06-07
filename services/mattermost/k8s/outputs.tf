output "mattermost_url" {
  value = "https://${var.domain}"
}

output "namespace" {
  value = kubernetes_namespace.mattermost.metadata[0].name
}
