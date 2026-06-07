resource "kubernetes_manifest" "mattermost_ingress" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind"       = "IngressRoute"
    "metadata" = {
      "name"      = "mattermost"
      "namespace" = kubernetes_namespace.mattermost.metadata[0].name
    }
    "spec" = {
      "entryPoints" = ["websecure"]
      "routes" = [
        {
          "match" = "Host(`${var.domain}`)"
          "kind"  = "Rule"
          "services" = [
            {
              "name" = kubernetes_service.mattermost.metadata[0].name
              "port" = 80
            }
          ]
        }
      ]
      "tls" = {
        "certResolver" = "myresolver"
      }
    }
  }
}
