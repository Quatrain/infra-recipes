resource "kubernetes_deployment" "mattermost" {
  metadata {
    name      = "mattermost"
    namespace = kubernetes_namespace.mattermost.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "mattermost"
      }
    }
    template {
      metadata {
        labels = {
          app = "mattermost"
        }
      }
      spec {
        security_context {
          fs_group = 2000
        }
        container {
          name  = "mattermost"
          image = var.mattermost_image
          env {
            name  = "MM_SQLSETTINGS_DRIVERNAME"
            value = "postgres"
          }
          env {
            name = "MM_SQLSETTINGS_DBPASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.db_pass.metadata[0].name
                key  = "password"
              }
            }
          }
          env {
            name  = "MM_SQLSETTINGS_DATASOURCE"
            value = "postgres://mmuser:$(MM_SQLSETTINGS_DBPASSWORD)@mattermost-db:5432/mattermost?sslmode=disable&connect_timeout=10"
          }
          env {
            name  = "MM_SERVICESETTINGS_SITEURL"
            value = "https://${var.domain}"
          }
          port {
            container_port = 8065
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
            name       = "mattermost-data"
            mount_path = "/mattermost/data"
          }
          volume_mount {
            name       = "mattermost-config"
            mount_path = "/mattermost/config"
          }
        }
        volume {
          name = "mattermost-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mattermost_data.metadata[0].name
          }
        }
        volume {
          name = "mattermost-config"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "mattermost" {
  metadata {
    name      = "mattermost"
    namespace = kubernetes_namespace.mattermost.metadata[0].name
  }
  spec {
    selector = {
      app = "mattermost"
    }
    port {
      port        = 80
      target_port = 8065
    }
  }
}
