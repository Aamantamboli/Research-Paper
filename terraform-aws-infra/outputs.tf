output "vpc_id" {

  value = aws_vpc.research_vpc.id

}

output "subnet_ids" {

  value = aws_subnet.public_subnets[*].id

}

output "ec2_instance_id" {

  value = aws_instance.research_instance.id

}

output "s3_bucket_name" {

  value = aws_s3_bucket.research_bucket.bucket

}
