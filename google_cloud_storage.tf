resource "google_storage_bucket" "compendium-data" {
  name                     = "compendium-data"
  location                 = "europe-west4" 
  force_destroy            = false
  project                  = var.google_project
  storage_class            = "NEARLINE"
  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "data-seeds" {
  name                     = "data-seeds"
  location                 = "europe-west4" 
  force_destroy            = false
  project                  = var.google_project
  storage_class            = "NEARLINE"
  public_access_prevention = "enforced"
}

resource "google_storage_bucket_object" "google_takeout" {
  for_each  = toset(var.google_takeout_source_list)
  
  name  = join("", ["google/takeout/", join("/", regex("(\\d{8}T\\d{6}Z)-(\\d{3}.zip)", each.key))])
  source = each.key
  bucket  = "data-seeds"

  content_type = "application/zip"
}

resource "google_storage_bucket_object" "spotify" {
  for_each = toset(var.spotify_source_list)

  name = join("", ["spotify/", join("/", regex("([^\\/]\\w+)-(\\d{8}T\\d{6}.zip)", each.key))])
  source = each.key
  bucket = "data-seeds"

  content_type = "application/zip"
}