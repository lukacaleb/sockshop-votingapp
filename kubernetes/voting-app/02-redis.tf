resource "kubernetes_deployment" "kube-redis-deployment" {
  metadata {
    name      = "redis-deployment"
    namespace =  kubernetes_namespace.kube-namespace.id
    labels = {
      name = "demo-voting-app"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        name = "redis-pod"
        app = "demo-voting-app"
      }
    }
    template {
      metadata {
        name =  "redis-pod"
        labels = {
          name = "redis-pod"
          app = "demo-voting-app"
        }
      }
      spec {
        container {
          image = "redis"
          name  = "redis"

      port {
        container_port = 6379
      }
      }
    }
  }
}
}



# Create kubernetes  for cart service

resource "kubernetes_service" "kube-redis-service" {
  metadata {
    name      = "redis"
    namespace =  kubernetes_namespace.kube-namespace.id
    /* annotations = {
        prometheus.io/scrape: "true"
    } */

    labels = {
        name = "redis-service"
        app = "demo-voting-app"
    }
  }
  spec {
    selector = {
      name = "redis-pod"
      app = "demo-voting-app"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}