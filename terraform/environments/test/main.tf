module "vpc" {
  source = "../../modules/vpc"

  env_name           = var.env_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "security_group" {
  source = "../../modules/security-group"

  env_name = var.env_name
  vpc_id   = module.vpc.vpc_id
  ssh_cidr = var.ssh_cidr
}

module "ec2" {
  source = "../../modules/ec2"

  env_name          = var.env_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = var.key_name
}