terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project_id
}

locals {
    install_script = file("install-tools.sh")
}

resource "google_compute_address" "static" {
  name   = "timesketch"
  region = var.region
}

resource "google_compute_disk" "default" {
  name  = "timesketch-data"
  type  = "pd-standard"
  zone  = var.zone
  labels = {
    environment = "lab"
  }
  size = 256
}

resource "google_compute_instance" "timesketch" {
  name         = "timesketch"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  attached_disk { 
    source = google_compute_disk.default.id
    device_name = google_compute_disk.default.name
  }

  network_interface {
    network = var.network
    access_config {
        nat_ip = google_compute_address.static.address
    }
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

  # required to allow access to gcs bucket w/ artifacts
  service_account {
    email  = var.service_account
    scopes = [ "https://www.googleapis.com/auth/cloud-platform"]
  }

  tags = ["timesketch", "lab"]
  metadata_startup_script = local.install_script
}

output "external_ip" {
    value       = google_compute_address.static.address
    description = "External IP of Timesketch instance"
}

output "message" {
    value = "To view output of startup script, connect to your instance and run the following command: sudo journalctl -u google-startup-scripts.service"
}