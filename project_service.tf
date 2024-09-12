# Enable services in newly created GCP Project.
resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)

  project = var.google_project
  service = each.value

  disable_dependent_services = true
}