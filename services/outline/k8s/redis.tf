resource "kubernetes_deployment" "outline_redis" {
  metadata {
    name      = "outline-redis"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "outline-redis"
      }
    }
    template {
      metadata {
        labels = {
          app = "outline-redis"
        }
      }
      spec {
        container {
          name    = "redis"
          image   = "redis:7-alpine"
          command = ["redis-server", "--requirepass", "$(REDIS_PASSWORD)"]
          env {
            name = "REDIS_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "redis-password"
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

resource "kubernetes_service" "outline_redis" {
  metadata {
    name      = "outline-redis"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  spec {
    selector = {
      app = "outline-redis"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}
