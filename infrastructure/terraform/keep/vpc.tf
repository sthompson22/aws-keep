resource "aws_vpc" "keep" {
  cidr_block           = "10.64.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name        = "keep"
    Environment = "keep"
    Region      = "ca-central-1"
  }
}

resource "aws_internet_gateway" "keep" {
  vpc_id = aws_vpc.keep.id

  tags = {
    Name        = "keep"
    Environment = "keep"
  }
}

# subnets
## public
resource "aws_subnet" "public-ca-central-1a" {
  vpc_id            = aws_vpc.keep.id
  cidr_block        = "10.64.2.0/24"
  availability_zone = "ca-central-1a"

  tags = {
    Name                         = "public-ca-central-1a"
    Environment                  = "keep"
    "kubernetes.io/cluster/keep" = "shared"
  }
}

resource "aws_subnet" "public-ca-central-1b" {
  vpc_id            = aws_vpc.keep.id
  cidr_block        = "10.64.4.0/24"
  availability_zone = "ca-central-1b"

  tags = {
    Name                         = "public-ca-central-1b"
    Environment                  = "keep"
    "kubernetes.io/cluster/keep" = "shared"
  }
}

resource "aws_subnet" "public-ca-central-1d" {
  vpc_id            = aws_vpc.keep.id
  cidr_block        = "10.64.6.0/24"
  availability_zone = "ca-central-1d"

  tags = {
    Name                         = "public-ca-central-1d"
    Environment                  = "keep"
    "kubernetes.io/cluster/keep" = "shared"
  }
}

## private
resource "aws_subnet" "private-ca-central-1a" {
  vpc_id            = aws_vpc.keep.id
  cidr_block        = "10.64.1.0/24"
  availability_zone = "ca-central-1a"

  tags = {
    Name                         = "private-ca-central-1a"
    Environment                  = "keep"
    "kubernetes.io/cluster/keep" = "shared"
  }
}

resource "aws_subnet" "private-ca-central-1b" {
  vpc_id            = aws_vpc.keep.id
  cidr_block        = "10.64.3.0/24"
  availability_zone = "ca-central-1b"

  tags = {
    Name                         = "private-ca-central-1b"
    Environment                  = "keep"
    "kubernetes.io/cluster/keep" = "shared"
  }
}

resource "aws_subnet" "private-ca-central-1d" {
  vpc_id            = aws_vpc.keep.id
  cidr_block        = "10.64.5.0/24"
  availability_zone = "ca-central-1d"

  tags = {
    Name                         = "private-ca-central-1d"
    Environment                  = "keep"
    "kubernetes.io/cluster/keep" = "shared"
  }
}

# routing
## public route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.keep.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.keep.id
  }

  tags = {
    Name        = "public"
    Environmnet = "keep"
  }
}

## private route tables: no private route table for az-a because we're not running a nat gateway there
resource "aws_route_table" "private-ca-central-1b" {
  vpc_id = aws_vpc.keep.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ca-central-1b.id
  }

  tags = {
    Name        = "private-ca-central-1b"
    Environmnet = "keep"
  }
}

resource "aws_route_table" "private-ca-central-1d" {
  vpc_id = aws_vpc.keep.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ca-central-1d.id
  }

  tags = {
    Name        = "private-ca-central-1d"
    Environmnet = "keep"
  }
}

## public routes
resource "aws_route_table_association" "public-ca-central-1a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public-ca-central-1a.id
}

resource "aws_route_table_association" "public-ca-central-1b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public-ca-central-1b.id
}

resource "aws_route_table_association" "public-ca-central-1d" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public-ca-central-1d.id
}

## private routes: no private route for az-a because we're not running a nat gateway there
resource "aws_route_table_association" "private-ca-central-1b" {
  route_table_id = aws_route_table.private-ca-central-1b.id
  subnet_id      = aws_subnet.private-ca-central-1b.id
}

resource "aws_route_table_association" "private-ca-central-1d" {
  route_table_id = aws_route_table.private-ca-central-1d.id
  subnet_id      = aws_subnet.private-ca-central-1d.id
}
