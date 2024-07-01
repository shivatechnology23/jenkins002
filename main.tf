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
  }
}
