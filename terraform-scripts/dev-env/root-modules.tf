module "vpc" {
    source                     = "../sub-script/vpc"
    name                       = var.name
    cidr_block                 = var.cidr_block 
    private_backend_subnets    = var.private_backend_subnets
    private_db_subnets         = var.private_db_subnets
    public_subnets             = var.public_subnets
  }

module "ec2" {
    source                     = "../sub-script/ec2"
    instance_name              = var.instance_name
    instance_ami_maven         = var.instance_ami_maven
    instance_ami_nginx         = var.instance_ami_nginx 
    instance_type              = var.instance_type
    key_name                   = var.key_name
    key_filename               = var.key_filename    
    frontend-subnet            = module.vpc.frontend-subnet
    backend-subnet             = module.vpc.backend-subnet
    sg                         = var.sg
    vpc-id                     = module.vpc.vpc-id 
    rds-sg                     = var.rds-sg 
}


module "rds" {
    source                     = "../sub-script/rds"
    parameter_group_name       = var.parameter_group_name 
    instance_class             = var.instance_class
    password                   = var.password
    username                   = var.username 
    db-subnet                  = module.vpc.db-subnet 
    rds_sg_id                  = module.ec2.rds_sg_id 
}

