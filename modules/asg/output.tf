output "external_asg_id" {
  value = aws_autoscaling_group.asg-1.id
}
output "external_asg_name" {
  value = aws_autoscaling_group.asg-1.name
}
output "external_asg_ax" {
  value = aws_autoscaling_group.asg-1.availability_zones
}
output "internal_asg_id" {
  value = aws_autoscaling_group.asg-2.id
}
output "internal_asg_name" {
  value = aws_autoscaling_group.asg-2.name_prefix
}
output "internal_asg_az" {
  value = aws_autoscaling_group.asg-2.availability_zones
}