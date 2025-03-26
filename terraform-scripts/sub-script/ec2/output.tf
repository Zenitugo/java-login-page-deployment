# Output the security group of the database

output "rds-sg-id" {
  value = aws_security_group.rds-sg.id
}