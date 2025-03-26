# Output the subnet IDs

output "frontend-subnet" {
    value = aws_subnet.public-subnet.id
  
}

output "backend-subnet" {
    value = aws_subnet.private-backend-subnet.id
  
}


output "db-subnet" {
    value = aws_subnet.private-db-subnet.id
}


# OutputVPC ID
output "vpc-id" {
    value = aws_vpc.login-vpc.id
  
}