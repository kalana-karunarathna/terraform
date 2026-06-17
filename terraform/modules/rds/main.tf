resource "aws_db_subnet_group" "this" {
  name       = "${var.env_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.env_name}-db-subnet-group"
    Environment = var.env_name
  }
}

resource "aws_db_instance" "this" {
  identifier             = "${var.env_name}-mysql-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_security_group_id]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name        = "${var.env_name}-mysql-db"
    Environment = var.env_name
  }
}