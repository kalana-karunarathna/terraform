output "dev_vpc_id" {
  value = module.vpc.vpc_id
}

output "dev_ec2_public_ip" {
  value = module.ec2.public_ip
}

output "dev_ec2_private_ip" {
  value = module.ec2.private_ip
}