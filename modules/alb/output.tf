output "external_alb_id" {
  value = aws_lb.web_external_lb.id
}

output "external_alb_target_arn" {
  value = aws_lb_target_group.web_attaching_1.arn
}

# output "external_alb_listener" {
#   value = aws_lb_listener.web_listener.id
# }



output "internal_alb_id" {
  value = aws_lb.app_internal_lb.id
}
output "internal_alb_arn" {
  value = aws_lb.app_internal_lb.arn
}

# output "internal_alb_target_arn" {
#   value = aws_lb_target_group.app_lb_attaching.arn
# }

# output "internal_alb_listener" {
#   value = aws_lb_listener.app_listener.id
# }