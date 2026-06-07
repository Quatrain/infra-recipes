resource "kubernetes_namespace" "mattermost" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "db_pass" {
  metadata {
    name      = "mattermost-db-pass"
    namespace = kubernetes_namespace.mattermost.metadata[0].name
  }
  data = {
    password = var.db_password
  }
}
