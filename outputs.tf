output "cluster_names" {
  value = [google_container_cluster.gke_cluster_1.name, google_container_cluster.gke_cluster_2.name]
}

output "load_balancer_ip" {
  value = google_compute_forwarding_rule.default.ip_address
}
