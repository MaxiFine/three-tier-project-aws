resource "aws_sns_topic" "mx_sns_notify_failover" {
  name = "cpu_alarm_topic"
}

resource "aws_sns_topic_subscription" "my_sns_topic_subscription" {
  # topic_arn = aws_sns_topic.mx_sns_topic.arn
  topic_arn = aws_sns_topic.mx_sns_notify_failover.arn
  protocol  = "email"
  endpoint  = var.email
}