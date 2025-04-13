module "vpc" {
    source                     = "../sub-script/vpc"
    name                       = var.name
    cidr_block                 = var.cidr_block 
    private_backend_subnets    = var.private_backend_subnets
    private_db_subnets         = var.private_db_subnets
    public_subnets             = var.public_subnets
  }

module "ec2-template" {
    source                     = "../sub-script/ec2-template"
    template_name1             = var.template_name1
    template_name2             = var.template_name2
    instance_name              = var.instance_name 
    instance_ami_maven         = var.instance_ami_maven
    instance_ami_nginx         = var.instance_ami_nginx 
    instance_type              = var.instance_type
    key_name                   = var.key_name
    key_filename               = var.key_filename    
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

module "autoscaling" {
    source                     = "../sub-script/autoscaling"
    frontend-template          = module.ec2-template.frontend-template
    backend-template           = module.ec2-template.backend-template
    backend-subnet             = module.vpc.backend-subnet
    frontend-subnet            = module.frontend-subnet
    desired_capacity           = var.desired_capacity
    max_size                   = var.max_size
    min_size                   = var.min_size  
    
}
