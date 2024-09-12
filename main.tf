terraform {
  required_version = "~> 1.9.5"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 6.2.0"
    }
  }

  backend "gcs" {
    bucket = "compendium-terraform"
    prefix = "data-infra"
  }
}

provider "google" {
  credentials = file(var.service_account_key_path)
  region = var.region
  project = var.google_project
}
