resource "aws_db_instance" "rds" {
  allocated_storage           = 10
  storage_type                = "gp2" 
  db_name                     = "mydb"
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = var.instance_class
  username                    = var.username
  password                    = var.password
  parameter_group_name        = var.parameter_group_name
  skip_final_snapshot         = true
  multi_az                    = true
  publicly_accessible         = false
  db_subnet_group_name        =  [var.db-subnet][count.index]
  vpc_security_group_ids      = var.rds-sg-id
}