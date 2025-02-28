resource "aws_sns_topic" "my_sns_topic" {
  name = "asg_cpu_alarm_topic"
}

resource "aws_sns_topic_subscription" "my_sns_topic_subscription" {
  topic_arn = aws_sns_topic.my_sns_topic.arn
  protocol  = "email"
  endpoint  = var.email
#   endpoint  = "gibboel5@gmail.com"
}