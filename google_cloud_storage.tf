# would be good to find a way to track the cheapest locations (Europe, Asia, Americas)

resource "google_storage_bucket" "compendium-test" {
  name                     = "compendium-test"
  location                 = var.region
  force_destroy            = false
  project                  = var.google_project
  storage_class            = "STANDARD"
  public_access_prevention = "enforced"

  # delete any objects in the test bucket after 7 days
  # anything stored here should not be critical and safe to delete
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 7 # days
    }
  }

  # disable soft delete for test bucket
  soft_delete_policy {
    retention_duration_seconds = 0
  }
}

resource "google_storage_bucket" "compendium-data" {
  name                     = "compendium-data"
  location                 = var.region
  force_destroy            = false
  project                  = var.google_project
  storage_class            = "NEARLINE"
  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "data-seeds" {
  name                     = "data-seeds"
  location                 = var.region
  force_destroy            = false
  project                  = var.google_project
  storage_class            = "NEARLINE"
  public_access_prevention = "enforced"
}

# use gsutil to upload the file since takeout files are huge
resource "null_resource" "upload_takeout_files" {
  provisioner "local-exec" {
    command = "gsutil cp ${each.value} gs://${google_storage_bucket.data-seeds.name}/google/takeout/${join("/", regex("(\\d{8}T\\d{6}Z)-(\\d{3}.zip)", each.value))}"
  }

  for_each = toset(var.google_takeout_source_list)
}

# NOTE: This was the code block I used before but it errors now
# I don't remember if it was an issue before as well but it is
# it is most likely due to the file being too large
#
# resource "google_storage_bucket_object" "google_takeout" {
#   for_each  = toset(var.google_takeout_source_list)

#   name  = join("", ["google/takeout/", join("/", regex("(\\d{8}T\\d{6}Z)-(\\d{3}.zip)", each.value))])
#   bucket  = google_storage_bucket.data-seeds.name

#   content_type = "application/zip"

#   depends_on = [null_resource.upload_takeout_files]
# }

resource "google_storage_bucket_object" "spotify" {
  for_each = toset(var.spotify_source_list)

  name   = join("", ["spotify/", join("/", regex("([^\\/-]\\w+)-(\\d{8}T\\d{6}.zip)", each.key))])
  source = each.key
  bucket = google_storage_bucket.data-seeds.name

  content_type = "application/zip"
}
