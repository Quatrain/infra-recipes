variable "namespace" {
  type    = string
  default = "traefik"
}

variable "acme_email" {
  type        = string
  description = "Email for Let's Encrypt certificates"
}

variable "dashboard_domain" {
  type        = string
  description = "Domain for Traefik dashboard"
}

variable "dashboard_auth_users" {
  type        = string
  description = "Basic Auth credentials (htpasswd format)"
}

variable "storage_class" {
  type    = string
  default = "sbs-default"
}
