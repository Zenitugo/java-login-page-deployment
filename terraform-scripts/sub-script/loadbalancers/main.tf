 ################## Network load balancer creation For the Frontend EC2's ######################

 resource "aws_lb" "nlb" {
  name               = "app-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public-subnet

  tags = {
    Environment = "dev"
  }
}



########## Target Group Creation ####################
resource "aws_lb_target_group" "nginx_tg" {
  name     = "nginx-target-group"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc-id
  target_type = "instance" # or "ip"
}

#################### Target Group Listener ################
resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}


############### Create a new ALB Target Group attachment ##################
resource "aws_autoscaling_attachment" "attachment" {
  autoscaling_group_name = var.frontend_asg
  lb_target_group_arn    = aws_lb_target_group.nginx_tg.arn
}




############################# Application load balancer for the Backend EC2's #########################

 resource "aws_lb" "backend_nlb" {
  name               = "backend-nlb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.backend-subnet

  tags = {
    Environment = "dev"
  }
}



########## Target Group Creation ####################
resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc-id
  target_type = "instance" # or "ip"
}

#################### Target Group Listener ################
resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_nlb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}


############### Create a new ALB Target Group attachment ##################
resource "aws_autoscaling_attachment" "backend_attachment" {
  autoscaling_group_name = var.backend_asg
  lb_target_group_arn    = aws_lb_target_group.backend_tg.arn
}
