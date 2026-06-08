output "outline_url" {
  value = "https://${var.domain}"
}

output "s3_url" {
  value = "https://${var.s3_domain}"
}

output "namespace" {
  value = kubernetes_namespace.outline.metadata[0].name
}
