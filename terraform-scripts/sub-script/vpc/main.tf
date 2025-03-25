######################### VPC CREATION #####################################

resource "aws_vpc" "login-vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.name
  }
}



######################### SUBNETS CREATION #####################################
resource "aws_subnet" "public-subnet" {
  count = 2 
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = var.public-subnets[count.index]
  availability_zone = data.aws_availability_zones.available.name[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = format("public-subnet %d", count.index+1)
  }
}

resource "aws_subnet" "private-subnet" {
  count = 4
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = var.private-subnets[count.index]
  availability_zone = data.aws_availability_zones.available.name[count.index]

  tags = {
    Name = format("private-subnet %d", count.index+1)
  }
}