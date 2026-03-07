output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.research_vpc.id
}

output "subnet_ids" {
  description = "List of all subnet IDs"
  value       = aws_subnet.public_subnets[*].id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "route_table_id" {
  description = "Route Table ID"
  value       = aws_route_table.public_rt.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.research_sg.id
}

output "ec2_instance_ids" {
  description = "List of all EC2 instance IDs"
  value       = aws_instance.research_instance[*].id
}

output "ec2_instance_count" {
  description = "Number of EC2 instances launched"
  value       = var.instance_count
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.research_bucket.bucket
}

output "ami_id_used" {
  description = "AMI ID used for EC2 instances"
  value       = data.aws_ami.amazon_linux.id
}
