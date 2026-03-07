provider "aws" {
  region = var.aws_region
}

# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "research_vpc" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# -----------------------------
# Availability Zones List
# -----------------------------
locals {
  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d",
    "us-east-1e",
    "us-east-1f"
  ]
}

# -----------------------------
# Public Subnets
# -----------------------------
resource "aws_subnet" "public_subnets" {

  count = 6

  vpc_id = aws_vpc.research_vpc.id

  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)

  availability_zone = local.azs[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# -----------------------------
# Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.research_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# -----------------------------
# Route Table
# -----------------------------
resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.research_vpc.id

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Internet Route
resource "aws_route" "internet_access" {

  route_table_id = aws_route_table.public_rt.id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.igw.id
}

# -----------------------------
# Route Table Associations
# -----------------------------
resource "aws_route_table_association" "public_assoc" {

  count = 6

  subnet_id = aws_subnet.public_subnets[count.index].id

  route_table_id = aws_route_table.public_rt.id
}

# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "research_sg" {

  name = "${var.project_name}-sg"

  vpc_id = aws_vpc.research_vpc.id

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# -----------------------------
# Get Latest Amazon Linux AMI
# -----------------------------
data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

# -----------------------------
# EC2 Instance
# -----------------------------
resource "aws_instance" "research_instance" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id = aws_subnet.public_subnets[0].id

  vpc_security_group_ids = [
    aws_security_group.research_sg.id
  ]

  tags = {
    Name = "${var.project_name}-ec2"
  }
}

# -----------------------------
# S3 Bucket
# -----------------------------
resource "aws_s3_bucket" "research_bucket" {

  bucket = var.bucket_name

  tags = {
    Name = "${var.project_name}-bucket"
  }
}