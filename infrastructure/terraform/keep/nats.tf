# nats: we're only using 2/3 AZ's here for cost savings
## elastic ips
resource "aws_eip" "nat-gateway-1b" {
  vpc = true

  tags = {
    Name        = "nat-gateway-1b"
    Environment = "keep"
  }
}

resource "aws_eip" "nat-gateway-1d" {
  vpc = true

  tags = {
    Name        = "nat-gateway-1d"
    Environment = "keep"
  }
}

## nat gateways
resource "aws_nat_gateway" "ca-central-1b" {
  depends_on    = [aws_internet_gateway.keep]
  allocation_id = aws_eip.nat-gateway-1b.id
  subnet_id     = aws_subnet.public-ca-central-1b.id

  tags = {
    Name        = "nat-gateway-1b"
    Environment = "keep"
  }
}

resource "aws_nat_gateway" "ca-central-1d" {
  depends_on    = [aws_internet_gateway.keep]
  allocation_id = aws_eip.nat-gateway-1d.id
  subnet_id     = aws_subnet.public-ca-central-1d.id

  tags = {
    Name        = "nat-gateway-1d"
    Environment = "keep"
  }
}
