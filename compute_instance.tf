resource "google_compute_address" "metabase-static-ip" {
  name = "metabase-static-ip"
}

resource "google_compute_instance" "metabase" {
  name                      = "metabase"
  machine_type              = var.metabase_vm_type
  zone                      = var.zone
  tags                      = ["http", "https", "ssh", "postgres", "dev"]
  allow_stopping_for_update = true
  deletion_protection = false
  depends_on = [google_compute_network.network, google_compute_subnetwork.subnetwork]


  # install docker (https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
  # setup metabase user
  metadata_startup_script = <<EOT
    sudo apt-get update
    sudo apt-get install --yes ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install --yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo adduser --gecos "" --disabled-password metabase
    chpasswd <<<"metabase:${var.vm_metabase_password}"
    sudo chmod 0750 /home/metabase
    sudo chage -m 5 -M 90 -W 14 metabase
  EOT

  labels = {
    "owner_id"   = "mighabana",
    "project_id" = "metabase"
  }

  boot_disk {
    initialize_params {
      image  = "ubuntu-os-cloud/ubuntu-2004-lts"
      size   = 20
    }
  }

  network_interface {
    network    = google_compute_network.network.name
    subnetwork = google_compute_subnetwork.subnetwork.name
    access_config {
      nat_ip = google_compute_address.metabase-static-ip.address
    }
  }

  service_account {
    email  = var.service_account
    scopes = ["cloud-platform", "https://www.googleapis.com/auth/drive.readonly"]
  }
  
  metadata = {
    google-monitoring-enabled = true
  }
}