######################### VPC CREATION #####################################

resource "aws_vpc" "login-vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.name}"-vpc
  }
}



######################### SUBNETS CREATION #####################################
resource "aws_subnet" "public-subnet" {
  count = 2 
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = var.public-subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = format("frontend-subnet %d", count.index+1)
  }
}

resource "aws_subnet" "private-backend-subnet" {
  count = 2
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = var.private-backend-subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("backend-subnet %d", count.index+1)
  }
}


resource "aws_subnet" "private-db-subnet" {
  count = 2
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = var.private-db-subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("database-subnet %d", count.index+1)
  }
}




################### INTERNET GATEWAY CREATION #######################
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "${var.name}"-gw
  }
}


##################### ELASTIC IP CREATION ########################
# Allocate an elastic ip address
resource "aws_eip" "eip" {
  count                     = 2
  vpc                       = true
   
  tags = {
    Name                    = format("eip %d", count.index+1)
  }
}



################ NAT GATEWAY CREATION ###############################
resource "aws_nat_gateway" "backend" {
  count         = 2
  allocation_id = element(aws_eip.eip.*.id, count.index)
  subnet_id     = element(aws_subnet.private-backend-subnet.*.id, count.index)

  depends_on = [aws_eip.eip,
                aws_subnet.private-backend-subnet]


  tags = {
    Name = format("nat-gw %d", count.index+1)
  }
}
