resource "kubernetes_deployment" "kube-db-deployment" {
  metadata {
    name      = "postgres-deployment"
    namespace =  kubernetes_namespace.kube-namespace.id
    labels = {
      name = "demo-voting-app"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        name = "postgres-pod"
        app = "demo-voting-app"
      }
    }
    template {
      metadata {
        name =  "postgres-pod"
        labels = {
          name = "postgres-pod"
          app = "demo-voting-app"
        }
      }
      spec {
        container {
          image = "postgres:9.4"
          name  = "postgres"

      env {
        name = "POSTGRES_HOST_AUTH_METHOD"
        value = "trust"
      }

      port {
        container_port = 5432
      }
      }
    }
  }
}
}



# Create kubernetes  for cart service

resource "kubernetes_service" "kube-db-service" {
  metadata {
    name      = "db"
    namespace = kubernetes_namespace.kube-namespace.id
    /* annotations = {
        prometheus.io/scrape: "true"
    } */

    labels = {
        name = "db-service"
        app = "demo-voting-app"
    }
  }
  spec {
    selector = {
      name = "postgres-pod"
      app = "demo-voting-app"
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}