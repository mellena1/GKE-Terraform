terraform {
  backend "gcs" {
    bucket  = "terraform-state-andrewmellenorg"
    prefix  = "gke-terraform/state"
  }
}
