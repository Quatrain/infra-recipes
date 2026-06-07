resource "kubernetes_deployment" "odoo_db" {
  metadata {
    name      = "odoo-db"
    namespace = kubernetes_namespace.odoo.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "odoo-db"
      }
    }
    template {
      metadata {
        labels = {
          app = "odoo-db"
        }
      }
      spec {
        container {
          name  = "db"
          image = "postgres:15-alpine"
          env {
            name  = "POSTGRES_DB"
            value = "postgres"
          }
          env {
            name  = "POSTGRES_USER"
            value = "odoo"
          }
          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_pass.metadata[0].name
                key  = "password"
              }
            }
          }
          port {
            container_port = 5432
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "1Gi"
            }
          }
          volume_mount {
            name       = "db-data"
            mount_path = "/var/lib/postgresql/data"
          }
        }
        volume {
          name = "db-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.odoo_db.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "odoo_db" {
  metadata {
    name      = "odoo-db"
    namespace = kubernetes_namespace.odoo.metadata[0].name
  }
  spec {
    selector = {
      app = "odoo-db"
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}
