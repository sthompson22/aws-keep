resource "helm_release" "openvpn" {
  name      = "openvpn"
  namespace = "default"
  chart     = "stable/openvpn"
  version   = "4.2.2"
  keyring   = ""

  set {
    name  = "openvpn.redirectGateway"
    value = "true"
  }
}
