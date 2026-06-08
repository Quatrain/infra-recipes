resource "kubernetes_manifest" "outline_ingress" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind"       = "IngressRoute"
    "metadata" = {
      "name"      = "outline"
      "namespace" = kubernetes_namespace.outline.metadata[0].name
    }
    "spec" = {
      "entryPoints" = ["websecure"]
      "routes" = [
        {
          "match" = "Host(`${var.domain}`)"
          "kind"  = "Rule"
          "services" = [
            {
              "name" = kubernetes_service.outline.metadata[0].name
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

resource "kubernetes_manifest" "minio_ingress" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind"       = "IngressRoute"
    "metadata" = {
      "name"      = "outline-minio"
      "namespace" = kubernetes_namespace.outline.metadata[0].name
    }
    "spec" = {
      "entryPoints" = ["websecure"]
      "routes" = [
        {
          "match" = "Host(`${var.s3_domain}`)"
          "kind"  = "Rule"
          "services" = [
            {
              "name" = kubernetes_service.outline_minio.metadata[0].name
              "port" = 9000
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
