resource "aws_security_group" "this" {
  name        = "${var.env_name}-security-group"
  description = "Security group for ${var.env_name} environment"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.env_name}-security-group"
    Environment = var.env_name
  }
}

resource "aws_security_group_rule" "ssh" {
  count = var.enable_ssh ? 1 : 0

  type              = "ingress"
  description       = "Allow SSH"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.ssh_cidr]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "http" {
  count = var.enable_ssh ? 1 : 0

  type              = "ingress"
  description       = "Allow HTTP"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.http_cidrs
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "https" {
  count = var.enable_ssh ? 1 : 0
  
  type              = "ingress"
  description       = "Allow HTTPS"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.https_cidrs
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "all_outbound" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "additional" {
  count = length(var.additional_ingress_rules)

  type              = "ingress"
  from_port         = var.additional_ingress_rules[count.index].from_port
  to_port           = var.additional_ingress_rules[count.index].to_port
  protocol          = var.additional_ingress_rules[count.index].protocol
  cidr_blocks       = [var.additional_ingress_rules[count.index].cidr]
  security_group_id = aws_security_group.this.id
}