provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "gke_cluster" {
  name               = var.cluster_name
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

resource "google_container_node_pool" "default_pool" {
  cluster           = google_container_cluster.gke_cluster.name
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

resource "google_compute_instance_group" "gke_node_group" {
  name        = "gke-node-group"
  zone        = "${var.region}-a"
  instances   = google_container_node_pool.default_pool.instance_group_urls

  lifecycle {
    ignore_changes = [instances]
  }
}

resource "google_compute_backend_service" "gke_backend" {
  name        = "gke-backend"
  backend {
    group = google_compute_instance_group.gke_node_group.self_link
  }

  health_checks = [google_compute_http_health_check.default.self_link]
  protocol      = "HTTP"
  port_name     = "http"
}

resource "google_compute_url_map" "gke_url_map" {
  name            = "gke-url-map"
  default_service = google_compute_backend_service.gke_backend.self_link
}

resource "google_compute_target_http_proxy" "gke_http_proxy" {
  name    = "gke-http-proxy"
  url_map = google_compute_url_map.gke_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "gke_forwarding_rule" {
  name        = "gke-forwarding-rule"
  target      = google_compute_target_http_proxy.gke_http_proxy.self_link
  port_range  = "80"
  ip_address  = google_compute_address.lb_address.address
}
