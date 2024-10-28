resource "google_network_management_connectivity_test" "metabase-cloudsql" {
  name = "metabase-cloudsql"

  source {
    instance     = google_compute_instance.metabase.id
    ip_address   = google_compute_instance.metabase.network_interface.0.network_ip
    network_type = "GCP_NETWORK"
  }

  destination {
    ip_address   = google_sql_database_instance.sql.private_ip_address
    port = 5432
  }

  description = "test postgres connection from metabase VM to cloudsql instance via private IP"
  protocol    = "TCP"
}