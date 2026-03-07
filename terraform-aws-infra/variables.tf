variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for all resource tags"
  type        = string
  default     = "terraform-research"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances to launch (1 for baseline trials, 3 for scalability test)"
  type        = number
  default     = 1
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}
