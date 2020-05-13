# for now still running StatefulSet configs out of yaml files

# client-0
## kube service
resource "kubernetes_service" "keep-beacon-client-0" {
  metadata {
    name      = "keep-beacon-client-0"
    namespace = "default"

    labels = {
      app  = "keep-client"
      type = "beacon"
      id   = "0"
    }
  }

  spec {
    selector = {
      app  = "keep-client"
      type = "beacon"
      id   = "0"
    }

    port {
      name        = "libp2p-peering"
      protocol    = "TCP"
      port        = 3920
      target_port = 3920
    }

    type = "LoadBalancer"
  }
}

# client-1
## kube service
resource "kubernetes_service" "keep-beacon-client-1" {
  metadata {
    name      = "keep-beacon-client-1"
    namespace = "default"

    labels = {
      app  = "keep-client"
      type = "beacon"
      id   = "1"
    }
  }

  spec {
    selector = {
      app  = "keep-client"
      type = "beacon"
      id   = "1"
    }

    port {
      name        = "libp2p-peering"
      protocol    = "TCP"
      port        = 3920
      target_port = 3920
    }

    type = "LoadBalancer"
  }
}
