resource "google_storage_bucket" "spotify" {
  name                     = "spotify_data"
  location                 = "europe-west4" 
  force_destroy            = false
  project                  = var.google_project
  storage_class            = "NEARLINE"
  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "google" {
  name                     = "google_data"
  location                 = "europe-west4" 
  force_destroy            = false
  project                  = var.google_project
  storage_class            = "NEARLINE"
  public_access_prevention = "enforced"
}