resource "kubernetes_namespace" "traefik" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume_claim" "traefik_acme" {
  metadata {
    name      = "traefik-acme-pvc"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = var.storage_class
  }
}

resource "kubernetes_service_account" "traefik" {
  metadata {
    name      = "traefik"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }
}
