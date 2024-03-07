resource "kubernetes_deployment" "kube-result-deployment" {
  metadata {
    name      = "result-app-deployment"
    namespace =  kubernetes_namespace.kube-namespace.id
    labels = {
      name = "demo-voting-app"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        name = "result-app-pod"
        app = "demo-voting-app"
      }
    }
    template {
      metadata {
        name =  "result-app-pod"
        labels = {
          name = "result-app-pod"
          app = "demo-voting-app"
        }
      }
      spec {
        container {
          image = "dockersamples/examplevotingapp_result"
          name  = "result-app"

      port {
        container_port = 80
      }
      }
    }
  }
}
}



# Create kubernetes  for cart service

resource "kubernetes_service" "kube-result-service" {
  metadata {
    name      = "result-service"
    namespace =  kubernetes_namespace.kube-namespace.id
   /*  annotations = {
        prometheus.io/scrape: "true"
    } */

    labels = {
        name = "result-service"
        app = "demo-voting-app"
    }
  }
  spec {
    selector = {
      name = "result-app-pod"
      app = "demo-voting-app"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}