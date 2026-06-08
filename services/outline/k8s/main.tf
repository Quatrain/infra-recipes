resource "kubernetes_namespace" "outline" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "outline_secrets" {
  metadata {
    name      = "outline-secrets"
    namespace = kubernetes_namespace.outline.metadata[0].name
  }
  data = {
    db-password         = var.db_password
    redis-password      = var.redis_password
    minio-root-user     = var.minio_root_user
    minio-root-password = var.minio_root_password
    google-client-id    = var.google_client_id
    google-client-secret = var.google_client_secret
    secret-key          = var.secret_key
    utils-secret        = var.utils_secret
  }
}
