# for now still running StatefulSet configs out of yaml files

# client-0
## kube service
resource "kubernetes_service" "keep-ecdsa-client-0" {
  metadata {
    name      = "keep-ecdsa-client-0"
    namespace = "default"

    labels = {
      app  = "keep-client"
      type = "ecdsa"
      id   = "0"
    }
  }

  spec {
    selector = {
      app  = "keep-client"
      type = "ecdsa"
      id   = "0"
    }

    port {
      name        = "libp2p-peering"
      protocol    = "TCP"
      port        = 4920
      target_port = 4920
    }

    type = "LoadBalancer"

  }
}
