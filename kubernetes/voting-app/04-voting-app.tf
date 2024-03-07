resource "kubernetes_deployment" "kube-voting-deployment" {
  metadata {
    name      = "voting-app-deployment"
    namespace =  kubernetes_namespace.kube-namespace.id
    labels = {
      name = "demo-voting-app"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        name = "voting-app-pod"
        app = "demo-voting-app"
      }
    }
    template {
      metadata {
        name =  "voting-app-pod"
        labels = {
          name = "voting-app-pod"
          app = "demo-voting-app"
        }
      }
      spec {
        container {
          image = "kodekloud/examplevotingapp_vote:v1"
          name  = "voting-app"

      port {
        container_port = 80
      }
      }
    }
  }
}
}



# Create kubernetes  for cart service

resource "kubernetes_service" "kube-voting-service" {
  metadata {
    name      = "voting-service"
    namespace =  kubernetes_namespace.kube-namespace.id
   /*  annotations = {
        prometheus.io/scrape: "true"
    } */

    labels = {
        name = "voting-service"
        app = "demo-voting-app"
    }
  }
  spec {
    selector = {
      name = "voting-app-pod"
      app = "demo-voting-app"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}