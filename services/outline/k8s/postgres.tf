resource "kubernetes_deployment" "outline_db" {
  metadata {
    name      = "outline-db"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "outline-db"
      }
    }
    template {
      metadata {
        labels = {
          app = "outline-db"
        }
      }
      spec {
        container {
          name  = "db"
          image = "postgres:15-alpine"
          env {
            name  = "POSTGRES_DB"
            value = "outline"
          }
          env {
            name  = "POSTGRES_USER"
            value = "outline"
          }
          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "db-password"
              }
            }
          }
          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
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
            claim_name = kubernetes_persistent_volume_claim.outline_db.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "outline_db" {
  metadata {
    name      = "outline-db"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  spec {
    selector = {
      app = "outline-db"
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}
