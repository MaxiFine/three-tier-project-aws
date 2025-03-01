output "app_alarm_increase_id" {
  value = aws_cloudwatch_metric_alarm.app_increase_ec2_alarm.id
}

output "app_alarm_increase_arn" {
  value = aws_cloudwatch_metric_alarm.app_increase_ec2_alarm
}

output "web_alarm_increase_id" {
  value = aws_cloudwatch_metric_alarm.web_increase_ec2_alarm.id
}
output "web_alarm_increase_arn" {
  value = aws_cloudwatch_metric_alarm.web_increase_ec2_alarm.arn
}

