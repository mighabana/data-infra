resource "google_bigquery_dataset" "bronze_spotify" {
  dataset_id    = "bronze_spotify"
  description   = "Raw data extracted from Spotify"
  location      = "europe-west4"

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = var.admin_email
  }
}

resource "google_bigquery_dataset" "bronze_google" {
  dataset_id    = "bronze_google"
  description   = "Raw data extracted from Google"
  location      = "europe-west4"

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = var.admin_email
  }
}