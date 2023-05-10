/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_compute_network" "vpc_network_1" {
  project                 = var.b_project
  name                    = "${var.e_prefix}-cr-private-network-1"
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_network_2" {
  project                 = var.b_project
  name                    = "${var.e_prefix}-cr-private-network-2"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private1" {
  name          = "${var.e_prefix}-cr-private-subnet-1"
  ip_cidr_range = var.f_subnet_1_CIDR
  network       = google_compute_network.vpc_network_1.id
  region        = var.c_region
}

resource "google_compute_subnetwork" "private2" {
  name                     = "${var.e_prefix}-cr-private-subnet-2"
  ip_cidr_range            = var.g_subnet_2_CIDR
  network                  = google_compute_network.vpc_network_1.id
  private_ip_google_access = true
  region                   = var.c_region
}

resource "google_compute_subnetwork" "private3-repl" {
  name          = "${var.e_prefix}-cr-private-subnet-3"
  ip_cidr_range = var.h_subnet_3_CIDR
  network       = google_compute_network.vpc_network_2.id
  region        = var.c_region
}

resource "google_compute_firewall" "private1-fw-in-rdp" {
  name      = "${var.e_prefix}-private1-firewall-ingress-rdp"
  network   = google_compute_network.vpc_network_1.name
  direction = "INGRESS"
  priority  = 100

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = [var.j_production_client_CIDR]
  target_tags   = ["cr-vault-jump-host-vm"]
}

resource "google_compute_firewall" "private1-fw-in-jh-ddve" {
  name      = "${var.e_prefix}-private1-firewall-ingress-jh-ddve"
  network   = google_compute_network.vpc_network_1.name
  direction = "INGRESS"
  priority  = 110

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_tags = ["cr-vault-jump-host-vm"]
  target_tags = ["cr-vault-ddve-vm"]
}

resource "google_compute_firewall" "private1-fw-in-jh-cr" {
  name      = "${var.e_prefix}-private1-firewall-ingress-jh-cr"
  network   = google_compute_network.vpc_network_1.name
  direction = "INGRESS"
  priority  = 120

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "14777-14778", "14780"]
  }

  source_tags = ["cr-vault-jump-host-vm"]
  target_tags = ["cr-vault-mgmt-host-vm"]
}

resource "google_compute_firewall" "private1-fw-in-cr-ddve" {
  name      = "${var.e_prefix}-private1-firewall-ingress-cr-ddve"
  network   = google_compute_network.vpc_network_1.name
  direction = "INGRESS"
  priority  = 130

  allow {
    protocol = "tcp"
    ports    = ["22", "111", "2049", "2052", "443"]
  }

  source_tags = ["cr-vault-mgmt-host-vm"]
  target_tags = ["cr-vault-ddve-vm"]
}

resource "google_compute_firewall" "private1-fw-out-jh-ddve" {
  name      = "${var.e_prefix}-private1-firewall-egress-jh-ddve"
  network   = google_compute_network.vpc_network_1.name
  direction = "EGRESS"
  priority  = 100
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags        = ["cr-vault-jump-host-vm"]
  destination_ranges = [google_compute_instance.ddve.network_interface[0].network_ip]
}

resource "google_compute_firewall" "private1-fw-out-jh-cr" {
  name      = "${var.e_prefix}-private1-firewall-egress-jh-cr"
  network   = google_compute_network.vpc_network_1.name
  direction = "EGRESS"
  priority  = 110
  allow {
    protocol = "tcp"
    ports    = ["22", "443", "14777-14778", "14780"]
  }
  target_tags        = ["cr-vault-jump-host-vm"]
  destination_ranges = [google_compute_instance.cr.network_interface[0].network_ip]
}

resource "google_compute_firewall" "private1-fw-out-cr-ddve" {
  name      = "${var.e_prefix}-private1-firewall-egress-cr-ddve"
  network   = google_compute_network.vpc_network_1.name
  direction = "EGRESS"
  priority  = 120

  allow {
    protocol = "tcp"
    ports    = ["22", "111", "2049", "2052", "443"]
  }
  target_tags        = ["cr-vault-mgmt-host-vm"]
  destination_ranges = [google_compute_instance.ddve.network_interface[0].network_ip]
}

resource "google_compute_firewall" "private1-fw-out-dd-cr-gcp" {
  name      = "${var.e_prefix}-private1-firewall-egress-dd-cr-gcp"
  network   = google_compute_network.vpc_network_1.name
  direction = "EGRESS"
  priority  = 130
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags        = ["cr-vault-ddve-vm", "cr-vault-mgmt-host-vm"]
  destination_ranges = ["8.8.4.0/24", "8.8.8.0/24", "8.35.200.0/21", "34.0.0.0/15", "34.2.0.0/16", "34.3.0.0/23", "34.3.3.0/24", "34.3.4.0/24", "34.3.8.0/21", "34.3.16.0/20", "34.3.32.0/19", "34.3.64.0/18", "34.3.128.0/17", "34.4.0.0/14", "34.8.0.0/13", "34.16.0.0/12", "34.32.0.0/11", "34.64.0.0/19", "34.96.0.0/18", "34.98.0.0/18", "34.98.136.0/21", "34.98.144.0/20", "34.98.160.0/19", "34.98.192.0/18", "34.99.0.0/16", "34.100.0.0/17", "34.101.0.0/20", "34.101.16.0/23", "34.101.19.0/24", "34.101.28.0/22", "34.103.0.0/16", "34.104.0.0/20", "34.104.16.0/21", "34.104.24.0/23", "34.104.26.0/24", "34.104.28.0/22", "34.104.32.0/20", "34.104.48.0/24", "34.104.53.0/24", "34.104.54.0/23", "34.109.0.0/16", "34.110.0.0/17", "34.112.0.0/14", "34.116.8.0/21", "34.116.16.0/20", "34.116.32.0/19", "34.118.208.0/20", "34.118.224.0/20", "34.119.0.0/16", "34.124.64.0/19", "34.124.96.0/20", "34.126.0.0/18", "34.126.224.0/19", "34.127.128.0/19", "34.127.160.0/20", "34.127.176.0/24", "34.127.181.0/24", "34.127.182.0/23", "34.127.192.0/18", "34.128.0.0/18", "34.128.192.0/18", "34.143.0.0/17", "34.144.0.0/17", "34.144.128.0/18", "34.152.64.0/18", "34.152.128.0/17", "34.153.0.0/16", "34.156.0.0/16", "34.157.10.0/23", "34.157.86.0/23", "34.157.90.0/23", "34.157.120.0/21", "34.157.138.0/23", "34.157.214.0/23", "34.157.216.0/22", "34.157.248.0/21", "34.158.0.0/16", "34.165.0.0/16", "34.166.0.0/15", "34.177.0.0/16", "34.178.0.0/15", "34.180.0.0/14", "34.184.0.0/13", "35.187.128.0/20", "35.190.96.0/20", "35.190.240.0/20", "35.191.0.0/16", "35.199.128.0/20", "35.201.32.0/21", "35.201.40.0/24", "35.201.42.0/23", "35.201.44.0/22", "35.201.48.0/20", "35.203.192.0/20", "35.203.208.0/23", "35.203.220.0/22", "35.203.224.0/21", "35.203.240.0/20", "35.206.0.0/21", "35.206.8.0/23", "35.206.12.0/22", "35.206.16.0/20", "35.218.0.0/16", "35.219.192.0/19", "35.220.28.0/23", "35.220.30.0/24", "35.229.0.0/20", "35.230.192.0/19", "35.230.224.0/20", "35.235.128.0/18", "35.235.192.0/20", "35.235.208.0/21", "35.235.224.0/19", "35.242.28.0/23", "35.242.30.0/24", "35.243.16.0/20", "35.243.48.0/21", "64.15.112.0/20", "64.233.160.0/19", "66.22.228.0/23", "66.102.0.0/20", "66.249.64.0/19", "70.32.128.0/19", "72.14.192.0/18", "74.114.24.0/21", "74.125.0.0/16", "104.154.0.0/20", "104.154.112.0/24", "104.154.122.0/23", "104.154.124.0/22", "104.155.240.0/20", "104.196.64.0/24", "104.196.72.0/21", "104.196.80.0/20", "104.199.64.0/23", "104.199.240.0/23", "104.237.160.0/19", "107.178.192.0/20", "107.178.224.0/20", "108.170.192.0/18", "108.177.0.0/17", "130.211.0.0/22", "136.112.0.0/12", "142.250.0.0/15", "146.148.0.0/23", "172.110.32.0/21", "172.217.0.0/16", "172.253.0.0/16", "173.194.0.0/16", "192.178.0.0/15", "193.186.4.0/24", "199.36.154.0/23", "199.36.156.0/24", "199.192.112.0/23", "199.192.114.0/24", "199.223.237.0/24", "199.223.238.0/23", "207.223.160.0/20", "208.65.152.0/22", "208.68.108.0/22", "208.81.188.0/22", "208.117.224.0/19", "209.85.128.0/17", "216.58.192.0/19", "216.73.80.0/20", "216.239.32.0/19"]
}

resource "google_compute_firewall" "private1-fw-in-deny-all" {
  name      = "${var.e_prefix}-private1-firewall-ingress-deny-all"
  network   = google_compute_network.vpc_network_1.name
  direction = "INGRESS"
  priority  = 65000

  deny {
    protocol = "all"
  }

  source_tags = ["dellfs"]
}

resource "google_compute_firewall" "private1-fw-out-deny-all" {
  name      = "${var.e_prefix}-private1-firewall-egress-deny-all"
  network   = google_compute_network.vpc_network_1.name
  direction = "EGRESS"
  priority  = 65000

  deny {
    protocol = "all"
  }
}

resource "google_compute_firewall" "private2-fw-in-deny" {
  name      = "${var.e_prefix}-private2-firewall-ingress-deny-all"
  network   = google_compute_network.vpc_network_2.name
  direction = "INGRESS"
  priority  = 65000

  deny {
    protocol = "all"
  }

  source_tags = ["dell-fs"]
}

resource "google_compute_firewall" "private2-fw-out-deny" {
  name      = "${var.e_prefix}-private2-firewall-egress-deny-all"
  network   = google_compute_network.vpc_network_2.name
  direction = "EGRESS"
  priority  = 65000

  deny {
    protocol = "all"
  }
}

resource "random_id" "bucket" {
  prefix      = "${var.e_prefix}-"
  byte_length = 8
}
resource "google_storage_bucket" "ddve-bucket" {
  name                        = "${random_id.bucket.hex}-bucket"
  location                    = var.c_region
  force_destroy               = false
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "ddve-bucket-iam" {
  bucket = google_storage_bucket.ddve-bucket.name
  role   = "projects/${var.b_project}/roles/${var.e_prefix}CrDdveRole"
  member = "serviceAccount:${google_service_account.ddve-sa.email}"
}

resource "google_project_iam_custom_role" "ddve-role" {
  project     = var.b_project
  role_id     = "${var.e_prefix}CrDdveRole"
  title       = "${var.e_prefix} Cyber Recovery DDVE Role"
  description = "Cyber Recovery DDVE Role for Object Access"
  permissions = ["storage.buckets.get", "storage.buckets.update", "storage.objects.create", "storage.objects.delete", "storage.objects.get", "storage.objects.list", "storage.objects.update"]
}

resource "google_service_account" "ddve-sa" {
  account_id   = "${var.e_prefix}-ddve-svc-accnt"
  display_name = "${var.e_prefix} Cyber Recovery DDVE service account"
}

resource "google_service_account_iam_binding" "ddve-binding" {
  service_account_id = google_service_account.ddve-sa.name
  role               = "projects/${var.b_project}/roles/${var.e_prefix}CrDdveRole"
  members = [
    "serviceAccount:${google_service_account.ddve-sa.email}"
  ]
}

resource "google_project_iam_custom_role" "cr-firewall-role" {
  project     = var.b_project
  role_id     = "${var.e_prefix}CrFirewallRole"
  title       = "${var.e_prefix} Cyber Recovery Firewall Role"
  description = "Cyber Recovery firewall role for updating VPC firewall rules"
  permissions = ["compute.instances.get", "compute.instances.list", "compute.firewalls.get", "compute.firewalls.list", "compute.firewalls.create", "compute.firewalls.delete", "compute.networks.updatePolicy"]
}

resource "google_service_account" "firewall-sa" {
  account_id   = "${var.e_prefix}-firewall-svc-accnt"
  display_name = "${var.e_prefix} Cyber Recovery firewall service account"
}

resource "google_project_iam_binding" "firewall-binding" {
  project = var.b_project
  role    = "projects/${var.b_project}/roles/${var.e_prefix}CrFirewallRole"
  members = [
    "serviceAccount:${google_service_account.firewall-sa.email}"
  ]
}

resource "google_compute_instance" "jh" {
  name         = "${var.e_prefix}-cr-jh"
  project      = var.b_project
  machine_type = "e2-standard-2"
  tags         = ["cr-vault-jump-host-vm"]
  network_interface {
    subnetwork = google_compute_subnetwork.private2.id
  }
  boot_disk {
    initialize_params {
      image = "projects/cis-public/global/images/cis-windows-server-2019-v1-3-0-3-level-2"
    }
  }
  metadata = {
    block-project-ssh-keys = true
  }
}

resource "google_compute_disk" "ddve-nvram" {
  name    = "${var.e_prefix}-cr-ddve-nvram"
  project = var.b_project
  type    = "pd-ssd"
  size    = 10
}

resource "google_compute_disk" "ddve-metadata" {
  name    = "${var.e_prefix}-cr-ddve-metadata"
  project = var.b_project
  type    = "pd-ssd"
  size    = 1024
}

resource "google_compute_instance" "ddve" {
  name         = "${var.e_prefix}-cr-ddve"
  project      = var.b_project
  machine_type = "e2-standard-4"
  tags         = ["cr-vault-ddve-vm"]
  network_interface {
    subnetwork = google_compute_subnetwork.private2.id
  }
  network_interface {
    subnetwork = google_compute_subnetwork.private3-repl.id
  }
  boot_disk {
    initialize_params {
      size  = 250
      type  = "pd-ssd"
      image = "projects/dellemc-ddve-public/global/images/ddve-gcp-7-7-0-0-1003850"
    }
  }
  attached_disk {
    source = google_compute_disk.ddve-nvram.name
  }
  attached_disk {
    source = google_compute_disk.ddve-metadata.name
  }
  service_account {
    email  = google_service_account.ddve-sa.email
    scopes = ["cloud-platform"]
  }
  metadata = {
    block-project-ssh-keys = true
  }
}

resource "google_compute_instance" "cr" {
  name         = "${var.e_prefix}-cr-mgmt"
  project      = var.b_project
  machine_type = "e2-standard-4"
  tags         = ["cr-vault-mgmt-host-vm"]
  network_interface {
    subnetwork = google_compute_subnetwork.private2.id
  }
  boot_disk {
    initialize_params {
      size  = 200
      image = "projects/ppdm-cdr/global/images/cr-19-12-0-01-image"
    }
  }
  service_account {
    email  = google_service_account.firewall-sa.email
    scopes = ["cloud-platform"]
  }
  metadata = {
    block-project-ssh-keys = true
  }
  metadata_startup_script = "#!/bin/bash -ex\nif [- f '/home/cruser/gcp_cr/startup_script_ran' ]; then exit 0; fi \ncd /home/cruser/gcp_cr/staging;\n./crsetup.sh --silent gcp;\ntouch /home/cruser/gcp_cr/startup_script_ran"
}
