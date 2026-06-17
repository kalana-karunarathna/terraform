module "vpc" {
  source = "../../modules/vpc"

  env_name             = var.env_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  availability_zone    = var.availability_zone
  public_subnet_cidr_2 = var.public_subnet_cidr_2
  availability_zone_2  = var.availability_zone_2
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

module "alb" {
  source = "../../modules/alb"

  env_name          = var.env_name
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.security_group.security_group_id
  instance_id       = module.ec2.instance_id
}

module "rds_security_group" {
  source = "../../modules/security-group"

  env_name = "prod-rds"
  vpc_id   = module.vpc.vpc_id
  ssh_cidr = var.ssh_cidr

  enable_ssh   = false
  enable_http  = false
  enable_https = false

  additional_ingress_rules = [
    {
      from_port = 3306
      to_port   = 3306
      protocol  = "tcp"
      cidr      = "10.2.0.0/16"
    }
  ]
}

module "rds" {
  source = "../../modules/rds"

  env_name             = var.env_name
  subnet_ids           = module.vpc.public_subnet_ids
  db_security_group_id = module.rds_security_group.security_group_id

  db_instance_class = "db.t3.micro"
  allocated_storage = 20
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
}

