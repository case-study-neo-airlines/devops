provider "google" {
  credentials = file("neoairlines-70069288f567.json")
  project     = var.project
  region      = var.location
}

provider "kubernetes" {
}

provider "helm" {
  install_tiller  = true
  service_account = kubernetes_service_account.tiller.metadata.0.name
  namespace       = "kube-system"
}