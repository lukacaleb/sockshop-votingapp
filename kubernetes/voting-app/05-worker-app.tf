resource "kubernetes_deployment" "kube-worker-deployment" {
  metadata {
    name      = "worker-app-deployment"
    namespace =  kubernetes_namespace.kube-namespace.id
    labels = {
      name = "demo-voting-app"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        name = "worker-app-pod"
        app = "demo-voting-app"
      }
    }
    template {
      metadata {
        name =  "worker-app-pod"
        labels = {
          name = "worker-app-pod"
          app = "demo-voting-app"
        }
      }
      spec {
        container {
          image = "dockersamples/examplevotingapp_worker"
          name  = "worker-app"
      }
    }
  }
}
}