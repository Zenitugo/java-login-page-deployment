region                       = "eu-central-1"
name                         = "login-page-vpc"
cidr_block                   = "10.0.0.0/16"
public-subnets               = ["10.0.1.0/24", "10.0.2.0/24"]
private-backend-subnets      = ["10.0.3.0/24", "10.0.4.0/24"]
private-db-subnets           = ["10.0.5.0/24", "10.0.6.0/24"] 