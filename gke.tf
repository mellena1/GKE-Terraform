resource "google_container_cluster" "k8s-cluster" {
  name = "andrewmellenorg"
  zone = "us-east1-b"
  remove_default_node_pool = true
  min_master_version = "1.10.7-gke.2"

  master_auth {
    username = ""
    password = ""
  }

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

resource "google_container_node_pool" "cheap-pool" {
  name = "cheap-pool"
  cluster = "${google_container_cluster.k8s-cluster.name}"
  zone = "us-east1-b"
  node_count = "1"

  node_config {
    machine_type = "f1-micro"
  }

  # autoscaling {
  #   min_node_count = 1
  #   max_node_count = 2
  # }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

resource "google_container_node_pool" "slightly-less-cheap-pool" {
  name = "slightly-less-cheap-pool"
  cluster = "${google_container_cluster.k8s-cluster.name}"
  zone = "us-east1-b"
  node_count = "1"

  node_config {
    machine_type = "g1-small"
  }

  # autoscaling {
  #   min_node_count = 1
  #   max_node_count = 2
  # }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

output "cluster_name" {
  value = "${google_container_cluster.k8s-cluster.name}"
}

output "zone" {
  value = "${google_container_cluster.k8s-cluster.zone}"
}