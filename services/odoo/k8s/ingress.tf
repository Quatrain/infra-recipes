resource "kubernetes_manifest" "odoo_ingress" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind"       = "IngressRoute"
    "metadata" = {
      "name"      = "odoo"
      "namespace" = kubernetes_namespace.odoo.metadata[0].name
    }
    "spec" = {
      "entryPoints" = ["websecure"]
      "routes" = [
        {
          "match" = "Host(`${var.domain}`)"
          "kind"  = "Rule"
          "services" = [
            {
              "name" = kubernetes_service.odoo.metadata[0].name
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
