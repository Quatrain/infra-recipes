resource "kubernetes_deployment" "outline_minio" {
  metadata {
    name      = "outline-minio"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "outline-minio"
      }
    }
    template {
      metadata {
        labels = {
          app = "outline-minio"
        }
      }
      spec {
        container {
          name    = "minio"
          image   = "minio/minio:RELEASE.2024-05-10T01-41-38Z"
          command = ["minio", "server", "/data", "--console-address", ":9001"]
          env {
            name = "MINIO_ROOT_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "minio-root-user"
              }
            }
          }
          env {
            name = "MINIO_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "minio-root-password"
              }
            }
          }
          port {
            container_port = 9000
          }
          port {
            container_port = 9001
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
            name       = "minio-data"
            mount_path = "/data"
          }
        }
        volume {
          name = "minio-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.outline_minio.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "outline_minio" {
  metadata {
    name      = "outline-minio"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  spec {
    selector = {
      app = "outline-minio"
    }
    port {
      name        = "api"
      port        = 9000
      target_port = 9000
    }
    port {
      name        = "console"
      port        = 9001
      target_port = 9001
    }
  }
}

resource "kubernetes_job" "create_minio_bucket" {
  metadata {
    name      = "create-outline-bucket"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  spec {
    template {
      spec {
        restart_policy = "OnFailure"
        container {
          name    = "mc"
          image   = "minio/mc:RELEASE.2024-05-09T17-04-24Z"
          command = [
            "/bin/sh",
            "-c",
            "sleep 10 && mc alias set myminio http://outline-minio:9000 $(MINIO_ROOT_USER) $(MINIO_ROOT_PASSWORD) && mc mb --ignore-existing myminio/outline && mc anonymous set public myminio/outline"
          ]
          env {
            name = "MINIO_ROOT_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "minio-root-user"
              }
            }
          }
          env {
            name = "MINIO_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.outline_secrets.metadata[0].name
                key  = "minio-root-password"
              }
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_deployment.outline_minio]
}
