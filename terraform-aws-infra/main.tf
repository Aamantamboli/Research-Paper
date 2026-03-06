# ------------------
# VPC
# ------------------
resource "aws_vpc" "research_vpc" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = "research-vpc"
  }
}

# ------------------
# Public Subnets
# ------------------
resource "aws_subnet" "public_subnets" {

  count = 6

  vpc_id = aws_vpc.research_vpc.id
  cidr_block = var.subnet_cidrs[count.index]

  availability_zone = var.availability_zone

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index+1}"
  }
}

# ------------------
# Internet Gateway
# ------------------
resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.research_vpc.id

  tags = {
    Name = "research-igw"
  }
}

# ------------------
# Route Table
# ------------------
resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.research_vpc.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "internet_route" {

  route_table_id = aws_route_table.public_rt.id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.igw.id
}

# ------------------
# Route Table Association
# ------------------
resource "aws_route_table_association" "subnet_assoc" {

  count = 6

  subnet_id = aws_subnet.public_subnets[count.index].id

  route_table_id = aws_route_table.public_rt.id
}

# ------------------
# Security Group
# ------------------
resource "aws_security_group" "research_sg" {

  name = "research-security-group"

  vpc_id = aws_vpc.research_vpc.id

  ingress {

    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}
