variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "ssh_cidr" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "public_subnet_cidr_2" {
  type = string
}

variable "availability_zone_2" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}