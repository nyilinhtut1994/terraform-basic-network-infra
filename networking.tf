#creating a vpc
resource "aws_vpc" "test" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

#create an internet gw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = var.name
  }
}

#create a public subnet
resource "aws_subnet" "public-test" {
  vpc_id                  = aws_vpc.test.id
  count                   = length(var.public_cidr)
  cidr_block              = var.public_cidr[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

#create a private subnet
resource "aws_subnet" "private-test" {
  vpc_id            = aws_vpc.test.id
  count             = length(var.private_cidr)
  cidr_block        = var.private_cidr[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}

#create a public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public route-table"
  }
}

#create a private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "private route-table"
  }
}

#associate the route table for the public and private
resource "aws_route_table_association" "public" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public-test[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_cidr)
  subnet_id      = aws_subnet.private-test[count.index].id
  route_table_id = aws_route_table.private.id
}