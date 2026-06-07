resource "kubernetes_secret" "dashboard_auth" {
  metadata {
    name      = "dashboard-auth"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }
  data = {
    users = var.dashboard_auth_users
  }
}

resource "kubernetes_manifest" "dashboard_middleware" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind"       = "Middleware"
    "metadata" = {
      "name"      = "dashboard-auth"
      "namespace" = kubernetes_namespace.traefik.metadata[0].name
    }
    "spec" = {
      "basicAuth" = {
        "secret" = kubernetes_secret.dashboard_auth.metadata[0].name
      }
    }
  }
}

resource "kubernetes_manifest" "dashboard_ingress" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind"       = "IngressRoute"
    "metadata" = {
      "name"      = "traefik-dashboard"
      "namespace" = kubernetes_namespace.traefik.metadata[0].name
    }
    "spec" = {
      "entryPoints" = ["websecure"]
      "routes" = [
        {
          "match" = "Host(`${var.dashboard_domain}`)"
          "kind"  = "Rule"
          "middlewares" = [
            {
              "name"      = "dashboard-auth"
              "namespace" = kubernetes_namespace.traefik.metadata[0].name
            }
          ]
          "services" = [
            {
              "name" = "api@internal"
              "kind" = "TraefikService"
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
