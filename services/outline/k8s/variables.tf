variable "namespace" {
  type    = string
  default = "outline"
}

variable "domain" {
  type        = string
  description = "Domain name for Outline (e.g., docs.example.com)"
}

variable "s3_domain" {
  type        = string
  description = "Domain name for the MinIO S3 API (e.g., s3-docs.example.com)"
}

variable "outline_image" {
  type    = string
  default = "outlinewiki/outline:0.75.2"
}

variable "db_password" {
  type        = string
  description = "Password for PostgreSQL database"
}

variable "redis_password" {
  type        = string
  description = "Password for Redis"
}

variable "minio_root_user" {
  type    = string
  default = "outline_admin"
}

variable "minio_root_password" {
  type        = string
  description = "Password for MinIO Root User"
}

variable "google_client_id" {
  type        = string
  description = "Google OAuth Client ID"
}

variable "google_client_secret" {
  type        = string
  description = "Google OAuth Client Secret"
}

variable "secret_key" {
  type        = string
  description = "Outline 32-byte hex secret key"
}

variable "utils_secret" {
  type        = string
  description = "Outline 32-byte hex utils secret"
}

variable "storage_class" {
  type    = string
  default = "sbs-default"
}

variable "db_storage_size" {
  type    = string
  default = "10Gi"
}

variable "minio_storage_size" {
  type    = string
  default = "10Gi"
}
