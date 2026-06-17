resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.env_name}-vpc"
    Environment = var.env_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.env_name}-igw"
    Environment = var.env_name
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.env_name}-public-subnet"
    Environment = var.env_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.env_name}-public-route-table"
    Environment = var.env_name
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public_2" {
  count = var.public_subnet_cidr_2 != "" ? 1 : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.env_name}-public-subnet-2"
    Environment = var.env_name
  }
}

resource "aws_route_table_association" "public_2" {
  count = var.public_subnet_cidr_2 != "" ? 1 : 0

  subnet_id      = aws_subnet.public_2[0].id
  route_table_id = aws_route_table.public.id
}