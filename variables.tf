# --------------------------------- GCP -----------------------------------
variable "google_project" {
  type        = string
  description = "Google Project ID"
}

variable "region" {
  type        = string
  description = "Region value to use for creating resources"
  default     = "asia-southeast1"
}

variable "zone" {
  type        = string
  description = "Zone value to use for creating resources"
  default     = "asia-southeast1-a"
}

variable "admin_email" {
  type        = string
  description = "Admin user's email address"
}

variable "service_account" {
  type        = string
  description = "Service Account Email"
}

variable "service_account_key_path" {
  type        = string
  description = "Service Account JSON key path"
}

variable "gcp_service_list" {
  type        = list(string)
  description = "List of API services to enable"
}
