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
