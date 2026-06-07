output "odoo_url" {
  value = "https://${var.domain}"
}

output "namespace" {
  value = kubernetes_namespace.odoo.metadata[0].name
}
