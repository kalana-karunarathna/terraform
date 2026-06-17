variable "env_name" {
  description = "Environment name such as dev, test, or prod"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}

variable "public_subnet_cidr_2" {
  description = "Optional second public subnet CIDR"
  type        = string
  default     = ""
}

variable "availability_zone_2" {
  description = "Optional second availability zone"
  type        = string
  default     = ""
}