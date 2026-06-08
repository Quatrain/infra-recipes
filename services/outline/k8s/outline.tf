resource "kubernetes_deployment" "outline" {
  metadata {
    name      = "outline"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "outline"
      }
    }
    template {
      metadata {
        labels = {
          app = "outline"
        }
      }
      spec {
        container {
          name  = "outline"
          image = var.outline_image
          env {
            name  = "NODE_ENV"
            value = "production"
          }
          env {
            name  = "URL"
            value = "https://${var.domain}"
          }
          env {
            name  = "PORT"
            value = "3000"
          }
          env {
            name = "SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "secret-key"
              }
            }
          }
          env {
            name = "UTILS_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "utils-secret"
              }
            }
          }
          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "db-password"
              }
            }
          }
          # We reconstruct the DATABASE_URL here using the password
          env {
            name  = "DATABASE_URL_AUTH"
            value = "postgres://outline:$(DATABASE_URL)@outline-db:5432/outline"
          }
          env {
            name  = "PGSSLMODE"
            value = "disable"
          }
          env {
            name = "REDIS_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "redis-password"
              }
            }
          }
          env {
            name  = "REDIS_URL"
            value = "redis://default:$(REDIS_PASSWORD)@outline-redis:6379"
          }
          # Authentication
          env {
            name = "GOOGLE_CLIENT_ID"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "google-client-id"
              }
            }
          }
          env {
            name = "GOOGLE_CLIENT_SECRET"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "google-client-secret"
              }
            }
          }
          # S3 Config
          env {
            name  = "AWS_REGION"
            value = "us-east-1"
          }
          env {
            name  = "AWS_S3_UPLOAD_BUCKET_URL"
            value = "https://${var.s3_domain}"
          }
          env {
            name  = "AWS_S3_UPLOAD_BUCKET_NAME"
            value = "outline"
          }
          env {
            name  = "AWS_S3_UPLOAD_MAX_SIZE"
            value = "26214400"
          }
          env {
            name  = "AWS_S3_FORCE_PATH_STYLE"
            value = "true"
          }
          env {
            name  = "AWS_S3_ACL"
            value = "public-read"
          }
          env {
            name = "AWS_ACCESS_KEY_ID"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "minio-root-user"
              }
            }
          }
          env {
            name = "AWS_SECRET_ACCESS_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "minio-root-password"
              }
            }
          }
          port {
            container_port = 3000
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
          # Override command to use the interpolated env vars
          command = ["/bin/sh", "-c", "export DATABASE_URL=$DATABASE_URL_AUTH && yarn start"]
        }
      }
    }
  }
}

resource "kubernetes_service" "outline" {
  metadata {
    name      = "outline"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  spec {
    selector = {
      app = "outline"
    }
    port {
      port        = 80
      target_port = 3000
    }
  }
}
