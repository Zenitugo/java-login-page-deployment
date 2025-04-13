

# Creation of the subnet group that contains the private subnets created for the database
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.db-subnet  # This should be a list of 2 private subnet IDs

  tags = {
    Name = "db-subnet-group"
  }
}




# Creation of the RDS
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
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids      = [var.rds_sg_id]
}