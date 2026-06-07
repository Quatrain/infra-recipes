resource "kubernetes_persistent_volume_claim" "nextcloud_main" {
  metadata {
    name      = "nextcloud-main-pvc"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.main_storage_size
      }
    }
    storage_class_name = var.storage_class
  }
}

resource "kubernetes_persistent_volume_claim" "nextcloud_db" {
  metadata {
    name      = "nextcloud-db-pvc"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    storage_class_name = var.storage_class
  }
}
