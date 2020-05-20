# hosted zone
## had to be imported since the domain registration created the hosted zone
data "aws_route53_zone" "mazeltov" {
  name         = "mazeltov.network."
  private_zone = false
}

# records
resource "aws_route53_record" "keep-beacon-client-0" {
  zone_id = data.aws_route53_zone.mazeltov.zone_id
  name    = "keep-beacon-client-0.${data.aws_route53_zone.mazeltov.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [kubernetes_service.keep-beacon-client-0.load_balancer_ingress["0"].hostname]
}


resource "aws_route53_record" "keep-beacon-client-1" {
  zone_id = data.aws_route53_zone.mazeltov.zone_id
  name    = "keep-beacon-client-1.${data.aws_route53_zone.mazeltov.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [kubernetes_service.keep-beacon-client-1.load_balancer_ingress["0"].hostname]
}

resource "aws_route53_record" "keep-ecdsa-client-0" {
  zone_id = data.aws_route53_zone.mazeltov.zone_id
  name    = "keep-ecdsa-client-0.${data.aws_route53_zone.mazeltov.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [kubernetes_service.keep-ecdsa-client-0.load_balancer_ingress["0"].hostname]
}
