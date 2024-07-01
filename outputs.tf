output "cluster_names" {
  value = google_container_cluster.gke_clusters[*].name
}

output "kubeconfig" {
  value = google_container_cluster.gke_clusters[*].endpoint
}
