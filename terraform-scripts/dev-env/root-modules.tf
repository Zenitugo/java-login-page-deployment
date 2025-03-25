module "vpc" {
    source                     = "../sub-script/vpc"
    name                       = var.name
    cidr_block                 = var.cidr_block 
    private-subnets            = var.private-subnets
    public-subnets             = var.public-subnets 
  
}