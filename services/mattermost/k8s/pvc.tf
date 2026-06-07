resource "kubernetes_persistent_volume_claim" "mattermost_data" {
  metadata {
    name      = "mattermost-data-pvc"
    namespace = kubernetes_namespace.mattermost.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.data_storage_size
      }
    }
    storage_class_name = var.storage_class
  }
}

resource "kubernetes_persistent_volume_claim" "mattermost_db" {
  metadata {
    name      = "mattermost-db-pvc"
    namespace = kubernetes_namespace.mattermost.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.db_storage_size
      }
    }
    storage_class_name = var.storage_class
  }
}
