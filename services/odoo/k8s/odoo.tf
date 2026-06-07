resource "kubernetes_deployment" "odoo" {
  metadata {
    name      = "odoo"
    namespace = kubernetes_namespace.odoo.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "odoo"
      }
    }
    template {
      metadata {
        labels = {
          app = "odoo"
        }
      }
      spec:
        dynamic "image_pull_secrets" {
          for_each = var.image_pull_secret != null ? [1] : []
          content {
            name = var.image_pull_secret
          }
        }
        container {

          name  = "odoo"
          image = var.odoo_image
          env {
            name  = "HOST"
            value = "odoo-db"
          }
          env {
            name  = "USER"
            value = "odoo"
          }
          env {
            name = "PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_pass.metadata[0].name
                key  = "password"
              }
            }
          }
          port {
            container_port = 8069
          }
          resources {
            requests = {
              cpu    = "200m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1000m"
              memory = "2Gi"
            }
          }
          volume_mount {
            name       = "odoo-data"
            mount_path = "/var/lib/odoo"
          }
          volume_mount {
            name       = "odoo-addons"
            mount_path = "/mnt/extra-addons"
          }
          volume_mount {
            name       = "odoo-config"
            mount_path = "/etc/odoo/odoo.conf"
            sub_path   = "odoo.conf"
          }
        }
        volume {
          name = "odoo-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.odoo_data.metadata[0].name
          }
        }
        volume {
          name = "odoo-addons"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.odoo_addons.metadata[0].name
          }
        }
        volume {
          name = "odoo-config"
          config_map {
            name = kubernetes_config_map.odoo_config.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "odoo" {
  metadata {
    name      = "odoo"
    namespace = kubernetes_namespace.odoo.metadata[0].name
  }
  spec {
    selector = {
      app = "odoo"
    }
    port {
      port        = 80
      target_port = 8069
    }
  }
}
