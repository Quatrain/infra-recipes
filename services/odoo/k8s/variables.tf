variable "namespace" {
  type    = string
  default = "odoo"
}

variable "domain" {
  type        = string
  description = "Domain name for Odoo"
}

variable "odoo_image" {
  type    = string
  default = "odoo:16.0"
}

variable "db_password" {
  type        = string
  description = "Password for Postgres database"
}

variable "admin_password" {
  type        = string
  description = "Master password for Odoo"
}

variable "storage_class" {
  type    = string
  default = "sbs-default"
}

variable "data_storage_size" {
  type    = string
  default = "10Gi"
}

variable "db_storage_size" {
  type    = string
  default = "5Gi"
}
