resource "kubernetes_persistent_volume_claim" "odoo_data" {
  metadata {
    name      = "odoo-data-pvc"
    namespace = kubernetes_namespace.odoo.metadata[0].name
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

resource "kubernetes_persistent_volume_claim" "odoo_db" {
  metadata {
    name      = "odoo-db-pvc"
    namespace = kubernetes_namespace.odoo.metadata[0].name
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

resource "kubernetes_persistent_volume_claim" "odoo_addons" {
  metadata {
    name      = "odoo-addons-pvc"
    namespace = kubernetes_namespace.odoo.metadata[0].name
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
