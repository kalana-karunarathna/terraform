output "prod_vpc_id" {
  value = module.vpc.vpc_id
}

output "prod_ec2_public_ip" {
  value = module.ec2.public_ip
}

output "prod_ec2_private_ip" {
  value = module.ec2.private_ip
}

output "prod_alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "prod_rds_endpoint" {
  value = module.rds.rds_endpoint
}