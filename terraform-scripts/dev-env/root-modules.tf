module "vpc" {
    source                     = "../sub-script/vpc"
    name                       = var.name
    cidr_block                 = var.cidr_block 
    private-backend-subnets    = var.private-backend-subnets
    private-db-subnets         = var.private-db-subnets
    public-subnets             = var.public-subnets 
  
}