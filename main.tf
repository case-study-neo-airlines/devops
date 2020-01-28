resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 3

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}


resource "null_resource" "k8s_login" {

  provisioner "local-exec" {
    command = "sleep 10 &gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone  ${google_container_cluster.primary.location} --project ${var.project}"
  }

  depends_on = [google_container_node_pool.primary_preemptible_nodes]
}

//data "google_container_cluster" "primary" {
//  name     = "my-gke-cluster"
//  location = "us-central1"
//}

resource "kubernetes_namespace" "devops" {


  metadata {
    annotations = {
      name = "devops"
    }

    labels = {
      mylabel = "devops"
    }

    name = "devops"
  }

  depends_on = [null_resource.k8s_login]

}

resource "kubernetes_namespace" "dev" {

  metadata {
    annotations = {
      name = "dev"
    }

    labels = {
      mylabel = "dev"
    }

    name = "dev"
  }

  depends_on = [null_resource.k8s_login]
}

resource "kubernetes_namespace" "test" {

  metadata {
    annotations = {
      name = "test"
    }

    labels = {
      mylabel = "test"
    }

    name = "test"
  }

  depends_on = [null_resource.k8s_login]
}


resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "terraform-tiller"
    namespace = "kube-system"
  }

  automount_service_account_token = true
  depends_on                      = [null_resource.k8s_login]
}



resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "terraform-tiller"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind = "ServiceAccount"
    name = "terraform-tiller"

    api_group = ""
    namespace = "kube-system"
  }
  depends_on = [kubernetes_service_account.tiller]
}


resource "helm_release" "jenkins" {
  name      = "jenkins"
  chart     = "stable/jenkins"
  namespace = "devops"

  values = [
    "${file("jenkins-values.yml")}"
  ]

}


resource "helm_release" "prometheus" {
  name      = "prometheus"
  chart     = "stable/prometheus"
  namespace = "devops"


  values = [
    "${file("prometheus-values.yml")}"
  ]

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

resource "helm_release" "grafana" {
  name      = "grafana"
  chart     = "stable/grafana"
  namespace = "devops"


  values = [
    "${file("grafana-values.yml")}"
  ]

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

}

resource "helm_release" "sonarqube" {
  name      = "sonarqube"
  chart     = "stable/sonarqube"
  namespace = "devops"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

}
