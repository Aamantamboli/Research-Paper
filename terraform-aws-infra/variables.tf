variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "project_name" {
  default = "terraform-research"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "bucket_name" {
  description = "Unique S3 bucket name"
}
