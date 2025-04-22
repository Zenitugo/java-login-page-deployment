

output "asg" {
    value = aws_autoscaling_group.frontend-autoscale.id
}