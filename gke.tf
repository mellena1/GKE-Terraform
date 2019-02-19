resource "google_container_cluster" "k8s-cluster" {
  name = "andrewmellenorg"
  remove_default_node_pool = true
  min_master_version = "1.11.5-gke.5"
  zone = "us-east1-b"

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

resource "google_compute_address" "static-ip" {
  name = "ipv4-address"
}

resource "google_container_node_pool" "ingress" {
  name       = "ingress"
  zone       = "us-east1-b"
  cluster    = "${google_container_cluster.k8s-cluster.name}"
  node_count = 1
  version = "1.11.5-gke.5"

  management = {
    auto_repair  = true
    auto_upgrade = false
  }

  node_config {
    preemptible  = false
    machine_type = "f1-micro"
    disk_size_gb = 20

    taint = {
      key    = "ingress"
      value  = "true"
      effect = "NO_EXECUTE"
    }

    labels = {
      ingress = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_container_node_pool" "worker-n1-standard-2" {
  name       = "worker-n1-standard-2"
  zone       = "us-east1-b"
  cluster    = "${google_container_cluster.k8s-cluster.name}"
  node_count = 1
  version = "1.11.5-gke.5"

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

output "static-ip" {
  value = "${google_compute_address.static-ip.address}"
}

