provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "gke_clusters" {
  count            = length(var.cluster_names)
  name             = var.cluster_names[count.index]
  location         = var.region
  initial_node_count = var.node_count

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      startup-script = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y apache2
        systemctl enable apache2
        systemctl start apache2
      EOF
    }
  }

  remove_default_node_pool = true
}

resource "google_container_node_pool" "default_pool" {
  count             = length(var.cluster_names)
  cluster           = google_container_cluster.gke_clusters[count.index].name
  location          = var.region
  node_count        = var.node_count

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      startup-script = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y apache2
        systemctl enable apache2
        systemctl start apache2
      EOF
    }
  }
}

resource "google_compute_address" "lb_address" {
  name = "lb-address"
}

resource "google_compute_http_health_check" "default" {
  name                = "http-basic-check"
  request_path        = "/"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}

resource "google_compute_backend_service" "default" {
  name                  = "http-backend"
  health_checks         = [google_compute_http_health_check.default.self_link]
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 10
  # connection_draining {
  #   draining_timeout_sec = 10
  # }
}

resource "google_compute_url_map" "default" {
  name            = "http-map"
  default_service = google_compute_backend_service.default.self_link
}

resource "google_compute_target_http_proxy" "default" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_forwarding_rule" "default" {
  name        = "http-content-rule"
  target      = google_compute_target_http_proxy.default.self_link
  port_range  = "80"
  load_balancing_scheme = "EXTERNAL"
  ip_address  = google_compute_address.lb_address.address
}

resource "google_container_cluster" "gke_cluster_1" {
  name               = "gke-cluster-1"
  location           = var.region
  initial_node_count = var.node_count

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      startup-script = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y apache2
        systemctl enable apache2
        systemctl start apache2
      EOF
    }
  }

  remove_default_node_pool = true
}

resource "google_container_cluster" "gke_cluster_2" {
  name               = "gke-cluster-2"
  location           = var.region
  initial_node_count = var.node_count

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      startup-script = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y apache2
        systemctl enable apache2
        systemctl start apache2
      EOF
    }
  }

  remove_default_node_pool = true
}

resource "google_container_node_pool" "gke_cluster_1_node_pool" {
  cluster           = google_container_cluster.gke_cluster_1.name
  location          = var.region
  node_count        = var.node_count

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      startup-script = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y apache2
        systemctl enable apache2
        systemctl start apache2
      EOF
    }
  }
}

resource "google_container_node_pool" "gke_cluster_2_node_pool" {
  cluster           = google_container_cluster.gke_cluster_2.name
  location          = var.region
  node_count        = var.node_count

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      startup-script = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y apache2
        systemctl enable apache2
        systemctl start apache2
      EOF
    }
  }
}
