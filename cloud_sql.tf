resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.network.id
}

resource "google_service_networking_connection" "sql" {
  network                 = google_compute_network.network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
  provider = google-beta
}

resource "google_sql_database_instance" "sql" {
  name             = var.cloud_sql_instance_name
  region           = var.region
  database_version = "POSTGRES_15"
  deletion_protection = false

  depends_on = [
    google_service_networking_connection.sql,
  ]

  settings {
    tier = "db-custom-1-3840"

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.network.self_link
      enable_private_path_for_google_cloud_services = true
    }
  }
}

resource "google_sql_database" "metabase" {
  name      = "metabase"
  instance  = google_sql_database_instance.sql.name
  charset   = "UTF8"
  collation = "en_US.UTF8"
}

resource "google_sql_user" "metabase" {
  name     = "metabase"
  instance = google_sql_database_instance.sql.name
  password = var.cloud_sql_metabase_user_password
}

resource "google_sql_database" "prefect" {
  name      = "prefect"
  instance  = google_sql_database_instance.sql.name
  charset   = "UTF8"
  collation = "en_US.UTF8"
}

resource "google_sql_user" "prefect" {
  name      = "prefect"
  instance  = google_sql_database_instance.sql.name
  password  = var.cloud_sql_prefect_user_password
}