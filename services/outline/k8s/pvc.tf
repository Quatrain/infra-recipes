resource "kubernetes_persistent_volume_claim" "outline_db" {
  metadata {
    name      = "outline-db-pvc"
    namespace = kubernetes_namespace.outline.metadata[0].name
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

resource "kubernetes_persistent_volume_claim" "outline_minio" {
  metadata {
    name      = "outline-minio-pvc"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.minio_storage_size
      }
    }
    storage_class_name = var.storage_class
  }
}
