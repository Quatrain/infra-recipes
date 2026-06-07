resource "kubernetes_deployment" "traefik" {
  metadata {
    name      = "traefik"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }
  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "traefik"
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "traefik"
        }
      }
      spec {
        service_account_name = kubernetes_service_account.traefik.metadata[0].name
        
        security_context {
          fs_group = 65532
        }

        init_container {
          name  = "fix-acme-permissions"
          image = "busybox:latest"
          command = ["sh", "-c", "touch /data/acme.json && chmod 600 /data/acme.json || true"]
          security_context {
            run_as_user  = 65532
            run_as_group = 65532
          }
          volume_mount {
            name       = "data"
            mount_path = "/data"
          }
        }

        container {
          name  = "traefik"
          image = "docker.io/traefik:v3.5.3"
          args = [
            "--entryPoints.web.address=:8000/tcp",
            "--entryPoints.websecure.address=:8443/tcp",
            "--api.dashboard=true",
            "--providers.kubernetescrd",
            "--providers.kubernetesingress",
            "--entryPoints.websecure.http.tls=true",
            "--certificatesresolvers.myresolver.acme.email=${var.acme_email}",
            "--certificatesresolvers.myresolver.acme.storage=/data/acme.json",
            "--certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web"
          ]
          port {
            name           = "web"
            container_port = 8000
          }
          port {
            name           = "websecure"
            container_port = 8443
          }
          volume_mount {
            name       = "data"
            mount_path = "/data"
          }
        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.traefik_acme.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "traefik" {
  metadata {
    name      = "traefik"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }
  spec {
    type = "LoadBalancer"
    selector = {
      "app.kubernetes.io/name" = "traefik"
    }
    port {
      name        = "web"
      port        = 80
      target_port = 8000
    }
    port {
      name        = "websecure"
      port        = 443
      target_port = 8443
    }
  }
}
