module "vpc" {
    source                     = "../sub-script/vpc"
    name                       = var.name
    cidr_block                 = var.cidr_block 
  
}