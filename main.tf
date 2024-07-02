provider "google" {
  project = "webx-424701"
  region  = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "primary-gke-cluster"
  location = "us-central1-a"

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

resource "google_container_cluster" "secondary" {
  name     = "secondary-gke-cluster"
  location = "us-central1-b"

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}
