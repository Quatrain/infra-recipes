resource "kubernetes_deployment" "nextcloud" {
  metadata {
    name      = "nextcloud"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "nextcloud"
      }
    }
    template {
      metadata {
        labels = {
          app = "nextcloud"
        }
      }
      spec {
        container {
          name  = "app"
          image = "nextcloud:apache"
          env {
            name  = "MYSQL_HOST"
            value = "nextcloud-db"
          }
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
            name  = "REDIS_HOST"
            value = "nextcloud-redis"
          }
          env {
            name = "REDIS_HOST_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.redis_pass.metadata[0].name
                key  = "password"
              }
            }
          }
          env {
            name  = "NEXTCLOUD_TRUSTED_DOMAINS"
            value = var.domain
          }
          env {
            name  = "OVERWRITEHOST"
            value = var.domain
          }
          env {
            name  = "OVERWRITEPROTOCOL"
            value = "https"
          }
          env {
            name  = "TRUSTED_PROXIES"
            value = "10.0.0.0/8"
          }
          env {
            name  = "PHP_MEMORY_LIMIT"
            value = "1024M"
          }
          port {
            container_port = 80
          }
          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1000m"
              memory = "2Gi"
            }
          }
          volume_mount {
            name       = "nextcloud-main"
            mount_path = "/var/www/html"
          }
        }
        volume {
          name = "nextcloud-main"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nextcloud_main.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nextcloud" {
  metadata {
    name      = "nextcloud"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  spec {
    selector = {
      app = "nextcloud"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}
