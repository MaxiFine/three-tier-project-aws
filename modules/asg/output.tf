output "web_asg_id" {
  value = aws_autoscaling_group.web_asg.id
}
output "web_asg_arn" {
  value = aws_autoscaling_group.web_asg.arn
}
output "app_asg_arn" {
  value = aws_autoscaling_group.app_asg.arn
}
output "app_asg_id" {
  value = aws_autoscaling_group.app_asg.id
}

output "wep_asg_instance_arn" {
  value = aws_launch_template.web_asg_template.arn
}



output "web_increase_policy_arn" {
  value = aws_autoscaling_policy.web_increase_ec2_policy.arn
}
output "web_decrease_policy_arn" {
  value = aws_autoscaling_policy.web_reduce_ec2_policy.arn
}
output "app_increase_policy_arn" {
  value = aws_autoscaling_policy.app_increase_ec2_policy.arn
}
output "app_reduce_policy_arn" {
  value = aws_autoscaling_policy.app_reduce_ec2_policy.arn
}


# output "kep_pair" {
#   value = aws_key_pair.
# }

# In modules/alb/outputs.tf
output "external_alb_target_arn_" {
  value = aws_autoscaling_group.web_asg.arn
}

output "internal_alb_target_arn" {  # Fix: Use target group ARN, not ALB ARN
  value = aws_autoscaling_group.app_asg.arn
}