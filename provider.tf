provider "kubernetes" {
  alias    = "primary"
  host     = google_container_cluster.primary.endpoint
  username = var.k8s_user
  password = var.k8s_password

  client_certificate     = base64decode(google_container_cluster.primary.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.primary.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

provider "kubernetes" {
  alias    = "secondary"
  host     = google_container_cluster.secondary.endpoint
  username = var.k8s_user
  password = var.k8s_password

  client_certificate     = base64decode(google_container_cluster.secondary.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.secondary.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.secondary.master_auth[0].cluster_ca_certificate)
}
