variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default = "webx-424701"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "cluster_names" {
  description = "List of GKE cluster names"
  type        = list(string)
  default     = ["cluster-1", "cluster-2", "cluster-3"]
}

variable "node_count" {
  description = "Number of nodes in each cluster"
  type        = number
  default     = 1
}
