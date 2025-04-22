######################### VPC CREATION #####################################

resource "aws_vpc" "login-vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.name}-vpc"
  }
}



######################### SUBNETS CREATION #####################################
resource "aws_subnet" "public-subnet" {
  count = 2 
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = format("public-subnet %d", count.index+1)
  }
}


resource "aws_subnet" "private-frontend-subnet" {
  count = 2
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = var.private_frontend_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("fronted-subnet %d", count.index+1)
  }
}



resource "aws_subnet" "private-backend-subnet" {
  count = 2
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = var.private_backend_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("backend-subnet %d", count.index+1)
  }
}


resource "aws_subnet" "private-db-subnet" {
  count = 2
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = var.private_db_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("database-subnet %d", count.index+1)
  }
}




################### INTERNET GATEWAY CREATION #######################
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "${var.name}-gw"
  }
}


##################### ELASTIC IP CREATION ########################
# Allocate an elastic ip address
resource "aws_eip" "eip" {
  count                     = 4
  vpc                       = true
   
  tags = {
    Name                    = format("eip %d", count.index+1)
  }
}



################ NAT GATEWAY CREATION ###############################

resource "aws_nat_gateway" "frontend" {
  count         = 2
  allocation_id = element(aws_eip.eip.*.id, count.index)
  subnet_id     = element(aws_subnet.private-frontend-subnet.*.id, count.index)

  depends_on = [aws_eip.eip,
                aws_subnet.private-frontend-subnet]


  tags = {
    Name = format("nat-gw-frontend %d", count.index+1)
  }
}



resource "aws_nat_gateway" "backend" {
  count         = 2
  allocation_id = element(aws_eip.eip.*.id, count.index + 2)
  subnet_id     = element(aws_subnet.private-backend-subnet.*.id, count.index)

  depends_on = [aws_eip.eip,
                aws_subnet.private-backend-subnet]


  tags = {
    Name = format("nat-gw-backend %d", count.index+1)
  }
}


##################### ROUTE TABLES CREATION  ################################
resource "aws_route_table" "public-route-table" {
  count = 2
  vpc_id = aws_vpc.login-vpc.id

  route {
    cidr_block           = "0.0.0.0/0"
    gateway_id           = element(aws_internet_gateway.gw.*.id, count.index)
  }
  depends_on = [ aws_internet_gateway.gw ]
}


resource "aws_route_table" "frontend-route-table" {
  count = 2
  vpc_id = aws_vpc.login-vpc.id

  route {
    cidr_block           = "0.0.0.0/0"
    nat_gateway_id       = element(aws_nat_gateway.frontend.*.id, count.index)
  }
  depends_on = [ aws_nat_gateway.frontend ]
}




resource "aws_route_table" "backend-route-table" {
  count = 2
  vpc_id = aws_vpc.login-vpc.id

  route {
    cidr_block           = "0.0.0.0/0"
    nat_gateway_id       = element(aws_nat_gateway.backend.*.id, count.index)
  }
  depends_on = [ aws_nat_gateway.backend ]
}


################################ ROUTE TABLE ASSOCIATION CREATION ######################################
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.public-route-table.*.id, count.index)

  depends_on = [ aws_subnet.public-subnet,
                aws_route_table.public-route-table]
}



resource "aws_route_table_association" "frontend" {
  count          = 2
  subnet_id      = element(aws_subnet.private-frontend-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.frontend-route-table.*.id, count.index)

  depends_on = [ aws_subnet.private-frontend-subnet,
                 aws_route_table.frontend-route-table]
}



resource "aws_route_table_association" "backend" {
  count          = 2
  subnet_id      = element(aws_subnet.private-backend-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.backend-route-table.*.id, count.index)

  depends_on = [ aws_subnet.private-backend-subnet,
                 aws_route_table.backend-route-table]
}

