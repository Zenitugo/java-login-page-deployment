# Output the security group of the database

output "rds_sg_id" {
  value = aws_security_group.rds-sg.id
}


# Output the ec2 temolate for the front end
output "frontend-template"{
  value = aws_launch_template.web_template.id
}


# output the ec2 template for the backend
output "backend-template"{
  value = aws_launch_template.app_template.id
}