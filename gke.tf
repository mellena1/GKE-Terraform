resource "google_container_cluster" "k8s-cluster" {
  name = "andrewmellenorg"
  remove_default_node_pool = true
  min_master_version = "1.11.5-gke.5"
  zone = "us-east1-b"

  master_auth {
    username = ""
    password = ""
  }

  logging_service = "none"
  monitoring_service = "none"

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }
  }

  # Uncomment this if creating a new cluster
  # node_pool {
  #   name = "default-pool"
  #   node_count = "0"
  # }
}

resource "google_container_node_pool" "worker-n1-standard-2" {
  name       = "worker-n1-standard-2"
  zone       = "us-east1-b"
  cluster    = "${google_container_cluster.k8s-cluster.name}"
  node_count = 1
  version = "1.11.5-gke.5"

  autoscaling = {
    min_node_count = 1
    max_node_count = 1
  }

  management = {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = true
    machine_type = "n1-standard-2"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

output "cluster_name" {
  value = "${google_container_cluster.k8s-cluster.name}"
}

output "zone" {
  value = "${google_container_cluster.k8s-cluster.zone}"
}
