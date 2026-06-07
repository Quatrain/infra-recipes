resource "kubernetes_config_map" "odoo_config" {
  metadata {
    name      = "odoo-config"
    namespace = kubernetes_namespace.odoo.metadata[0].name
  }

  data = {
    "odoo.conf" = <<-EOF
      [options]
      addons_path = ${var.addons_path}
      data_dir = /var/lib/odoo
      db_name = ${var.db_name}
      db_host = odoo-db
      db_user = odoo
      db_password = ${var.db_password}
      admin_passwd = ${var.admin_password}
      proxy_mode = True
    EOF
  }
}
