resource "kubernetes_deployment" "nextcloud_redis" {
  metadata {
    name      = "nextcloud-redis"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "nextcloud-redis"
      }
    }
    template {
      metadata {
        labels = {
          app = "nextcloud-redis"
        }
      }
      spec {
        container {
          name    = "redis"
          image   = "redis:alpine"
          command = ["redis-server", "--requirepass", "$(REDIS_PASSWORD)"]
          env {
            name = "REDIS_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.redis_pass.metadata[0].name
                key  = "password"
              }
            }
          }
          port {
            container_port = 6379
          }
          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nextcloud_redis" {
  metadata {
    name      = "nextcloud-redis"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  spec {
    selector = {
      app = "nextcloud-redis"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}
