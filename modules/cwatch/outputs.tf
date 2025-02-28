output "app_increase_ec2_policy_id" {
  value = aws_cloudwatch_metric_alarm.app_increase_ec2_alarm.id

}
output "app_decrease_ec2_policy_arn" {
  value = aws_cloudwatch_metric_alarm.app_reduce_ec2_alarm.arn
}
output "web_increase_ec2_policy_arn" {
  value = aws_cloudwatch_metric_alarm.web_increase_ec2_alarm.arn
}
output "web_decrease_ec2_policy_id" {
  value = aws_cloudwatch_metric_alarm.web_reduce_ec2_alarm.arn
}
