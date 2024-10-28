resource "google_compute_network" "network" {
  name                     = "compendium-network"
  auto_create_subnetworks  = false
  mtu                      = 1300
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "compendium-network-subnetwork"
  ip_cidr_range = "10.9.0.0/16"
  region        = var.region
  network       = google_compute_network.network.id
}

resource "google_compute_firewall" "allow-http" {
  name      = "allow-http"
  network   = google_compute_network.network.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http"]
}

resource "google_compute_firewall" "allow-https" {
  name      = "allow-https"
  network   = google_compute_network.network.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https"]
}

resource "google_compute_firewall" "allow-ssh" {
  name      = "allow-ssh"
  network   = google_compute_network.network.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "allow-postgres" {
  name      = "allow-postgres"
  network   = google_compute_network.network.name
  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  destination_ranges = [ join("", [google_compute_global_address.private_ip_alloc.address,"/",google_compute_global_address.private_ip_alloc.prefix_length])]
  target_tags        = ["postgres"]
}

resource "google_compute_firewall" "dev-mode" {
  name = "dev-mode"
  network = google_compute_network.network.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["dev"]
}

resource "google_compute_firewall" "allow-icmp-tcp-internal" {
  name   = "allow-icmp-tcp-internal"
  network = google_compute_network.network.name
  direction = "EGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["443", "80"]
  }

  source_ranges = ["10.9.0.0/16"]
}
