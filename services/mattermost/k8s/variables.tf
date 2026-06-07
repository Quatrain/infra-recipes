variable "namespace" {
  type    = string
  default = "mattermost"
}

variable "domain" {
  type        = string
  description = "Domain name for Mattermost"
}

variable "mattermost_image" {
  type    = string
  default = "mattermost/mattermost-team-edition:9.8"
}

variable "db_password" {
  type        = string
  description = "Password for PostgreSQL database"
}

variable "storage_class" {
  type    = string
  default = "sbs-default"
}

variable "data_storage_size" {
  type    = string
  default = "50Gi"
}

variable "db_storage_size" {
  type    = string
  default = "10Gi"
}
