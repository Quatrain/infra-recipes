resource "kubernetes_manifest" "nextcloud_middleware" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind"       = "Middleware"
    "metadata" = {
      "name"      = "nextcloud-dav"
      "namespace" = kubernetes_namespace.nextcloud.metadata[0].name
    }
    "spec" = {
      "redirectRegex" = {
        "regex"       = "^\\.well-known/(card|cal)dav"
        "replacement" = "/remote.php/dav/"
      }
    }
  }
}

resource "kubernetes_manifest" "nextcloud_ingress" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind"       = "IngressRoute"
    "metadata" = {
      "name"      = "nextcloud"
      "namespace" = kubernetes_namespace.nextcloud.metadata[0].name
    }
    "spec" = {
      "entryPoints" = ["websecure"]
      "routes" = [
        {
          "match" = "Host(`${var.domain}`)"
          "kind"  = "Rule"
          "middlewares" = [
            {
              "name"      = "nextcloud-dav"
              "namespace" = kubernetes_namespace.nextcloud.metadata[0].name
            }
          ]
          "services" = [
            {
              "name" = kubernetes_service.nextcloud.metadata[0].name
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
