resource "google_bigquery_dataset" "bronze_spotify" {
  dataset_id  = "bronze_spotify"
  description = "Raw data extracted from Spotify"
  location    = var.region

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = var.admin_email
  }

  access {
    role          = "OWNER"
    user_by_email = var.service_account
  }
}

resource "google_bigquery_dataset" "bronze_google" {
  dataset_id  = "bronze_google"
  description = "Raw data extracted from Google"
  location    = var.region

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = var.admin_email
  }

  access {
    role          = "OWNER"
    user_by_email = var.service_account
  }
}

resource "google_bigquery_dataset" "bronze_open_alex" {
  dataset_id  = "bronze_open_alex"
  description = "Raw data extracted from OpenAlex"
  location    = var.region

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = var.admin_email
  }

  access {
    role          = "OWNER"
    user_by_email = var.service_account
  }
}
