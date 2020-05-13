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
  records = ["a22e8be63a1164cd190e4068e76fab09-1380995297.ca-central-1.elb.amazonaws.com"]
}


resource "aws_route53_record" "keep-beacon-client-1" {
  zone_id = data.aws_route53_zone.mazeltov.zone_id
  name    = "keep-beacon-client-1.${data.aws_route53_zone.mazeltov.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["ad3b2e544248a4efbb5027e2426c27a4-1248079851.ca-central-1.elb.amazonaws.com"]
}
