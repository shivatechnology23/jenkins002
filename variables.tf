

# variable "project_id" {
#   description = "The GCP project ID"
#   type        = string
#   default     = "webx-424701"
# }

# variable "region" {
#   description = "The GCP region"
#   type        = string
#   default     = "us-central1"
# }

# variable "cluster_name" {
#   description = "The GKE cluster name"
#   type        = string
#   default     = "my-cluster"
# }

# variable "node_count" {
#   description = "Number of nodes in the cluster"
#   type        = number
#   default     = 1
# }

variable "k8s_user" {
  description = "Kubernetes username"
  type        = string
  default = "user1"
}

variable "k8s_password" {
  description = "Kubernetes password"
  type        = string
  default = "password"
}

