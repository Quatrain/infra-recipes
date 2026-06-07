resource "kubernetes_namespace" "nextcloud" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "db_pass" {
  metadata {
    name      = "nextcloud-db-pass"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  data = {
    password      = var.db_password
    root-password = var.db_password
  }
}

resource "kubernetes_secret" "redis_pass" {
  metadata {
    name      = "nextcloud-redis-pass"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  data = {
    password = var.redis_password
  }
}
