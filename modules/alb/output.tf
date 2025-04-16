output "external_alb_id" {
  value = aws_lb.web_external_lb.id
}

output "external_alb_target_arn" {
  value = aws_lb_target_group.web_external_tgroup.arn
}
output "external_alb_zone_id" {
  value = aws_lb.web_external_lb.zone_id
}

output "external_alb_dns" {
  value = aws_lb.web_external_lb.dns_name
}
output "internal_alb_dns" {
  value = aws_lb.app_internal_lb.dns_name
}

output "app_alr_arn_2" {
  value = aws_lb_target_group.app_internal_tgroup.arn
}

output "internal_alb_id" {
  value = aws_lb.app_internal_lb.id
}
output "internal_alb_arn" {
  value = aws_lb.app_internal_lb.arn
}


# In modules/alb/outputs.tf
output "internal_alb_target_arn" {  # Fix: Use target group ARN, not ALB ARN
  value = aws_lb_target_group.app_internal_tgroup.arn
}