variable "namespace" {
  type    = string
  default = "nextcloud"
}

variable "domain" {
  type        = string
  description = "The domain name for Nextcloud (e.g. cloud.example.com)"
}

variable "db_password" {
  type        = string
  description = "Password for MySQL database"
}

variable "redis_password" {
  type        = string
  description = "Password for Redis"
}

variable "storage_class" {
  type    = string
  default = "sbs-default"
}

variable "main_storage_size" {
  type    = string
  default = "400Gi"
}
