output "nextcloud_url" {
  value = "https://${var.domain}"
}

output "namespace" {
  value = kubernetes_namespace.nextcloud.metadata[0].name
}
