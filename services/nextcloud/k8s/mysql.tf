resource "kubernetes_deployment" "nextcloud_db" {
  metadata {
    name      = "nextcloud-db"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "nextcloud-db"
      }
    }
    template {
      metadata {
        labels = {
          app = "nextcloud-db"
        }
      }
      spec {
        container {
          name  = "db"
          image = "mysql:8.0"
          args  = ["--default-authentication-plugin=mysql_native_password"]
          env {
            name  = "MYSQL_DATABASE"
            value = "nextcloud"
          }
          env {
            name  = "MYSQL_USER"
            value = "nextcloud"
          }
          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_pass.metadata[0].name
                key  = "password"
              }
            }
          }
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_pass.metadata[0].name
                key  = "root-password"
              }
            }
          }
          port {
            container_port = 3306
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
            mount_path = "/var/lib/mysql"
          }
        }
        volume {
          name = "db-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nextcloud_db.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nextcloud_db" {
  metadata {
    name      = "nextcloud-db"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  spec {
    selector = {
      app = "nextcloud-db"
    }
    port {
      port        = 3306
      target_port = 3306
    }
  }
}
