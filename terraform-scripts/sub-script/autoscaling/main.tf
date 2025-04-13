############### Create an autoscaling group ####################


############ ASG for the Frontend #######################

resource "aws_autoscaling_group" "frontend-autoscale" {
    name = "Frontend-ASG"
    vpc_zone_identifier = var.frontend-subnet 
    desired_capacity = var.desired_capacity
    max_size = var.max_size
    min_size = var.min_size

    launch_template {
      id      = var.frontend-template
      version = "$Default"
    }    
}


################### ASG for the Backend ####################

resource "aws_autoscaling_group" "backend-autoscale" {
    name = "Backend-ASG"
    vpc_zone_identifier = var.backend-subnet
    desired_capacity = var.desired_capacity
    max_size = var.max_size
    min_size = var.min_size

    launch_template {
      id      = var.backend-template
      version = "$Default"
    }    
}