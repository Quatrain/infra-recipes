resource "kubernetes_namespace" "odoo" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "db_pass" {
  metadata {
    name      = "odoo-db-pass"
    namespace = kubernetes_namespace.odoo.metadata[0].name
  }
  data = {
    password = var.db_password
  }
}

resource "kubernetes_secret" "odoo_secrets" {
  metadata {
    name      = "odoo-secrets"
    namespace = kubernetes_namespace.odoo.metadata[0].name
  }
  data = {
    admin-password = var.admin_password
  }
}
