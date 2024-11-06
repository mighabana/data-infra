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

variable "google_takeout_source_list" {
  type        = list(string)
  description = "List of paths to Google Takeout zip files"
}

variable "spotify_source_list" {
  type        = list(string)
  description = "List of paths to Spotify zip files"
}

variable "vm_metabase_password" {
  type = string
  description = "Password for the Metabase user on the Metabase compute instance"
}

variable "metabase_vm_type" {
  type        = string
  description = "VM type for the Metabase compute instance"
}

variable "cloud_sql_instance_name" {
  type        = string
  description = "Cloud SQL instance name"
}

variable "cloud_sql_metabase_user_password" {
  type = string
  description = "Password for the Metabase user on Cloud SQL"
}

variable "prefect_vm_type" {
  type = string
  description = "VM type for the Prefect compute instance"
}

variable "vm_prefect_password" {
  type = string
  description = "Password for the Prefect user on Prefect compute instance"
}

variable "cloud_sql_prefect_user_password" {
  type = string
  description = "Password for the Prefect user on Cloud SQL"
}