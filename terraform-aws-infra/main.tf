module "vpc" {
  source = "./modules/vpc"

  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  instance_type = var.instance_type
  security_group_id = module.vpc.security_group_id
}

module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
}
