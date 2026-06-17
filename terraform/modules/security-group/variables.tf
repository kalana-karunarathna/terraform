variable "env_name" {
  description = "Environment name such as dev, test, or prod"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
}

variable "http_cidrs" {
  description = "CIDR blocks allowed for HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_cidrs" {
  description = "CIDR blocks allowed for HTTPS access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "additional_ingress_rules" {
  description = "Additional ingress rules"
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = string
  }))
  default = []
}

variable "enable_ssh" {
  type    = bool
  default = true
}

variable "enable_http" {
  type    = bool
  default = true
}

variable "enable_https" {
  type    = bool
  default = true
}