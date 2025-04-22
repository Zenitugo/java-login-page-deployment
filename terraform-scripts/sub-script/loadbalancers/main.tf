 ################## Network load balancer creation ######################

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
  autoscaling_group_name = var.asg
  lb_target_group_arn    = aws_lb_target_group.nginx_tg.arn
}




