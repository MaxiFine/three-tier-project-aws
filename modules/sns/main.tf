resource "aws_sns_topic" "mx_sns_notify_failover" {
  name = "cpu_alarm_topic"
}

resource "aws_sns_topic_subscription" "my_sns_topic_subscription" {
  # topic_arn = aws_sns_topic.mx_sns_topic.arn
  topic_arn = aws_sns_topic.mx_sns_notify_failover.arn
  protocol  = "email"
  endpoint  = var.email
}

# Define an IAM policy that allows listing tags for the specific SNS topic
# resource "aws_iam_policy" "sns_list_tags" {
#   name        = "sns-list-tags-policy"
#   description = "Allow listing tags for SNS topics"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = "sns:ListTagsForResource"
#         Resource = "arn:aws:sns:eu-west-1:266735814394:cpu_alarm_topic"
#       }
#     ]
#   })
# }

# # Attach the policy to the IAM user
# resource "aws_iam_user_policy_attachment" "attach_sns_list_tags" {
#   user       = "max-aws-lab"
#   policy_arn = aws_iam_policy.sns_list_tags.arn
# }

# # Your existing SNS topic and subscription resources
# resource "aws_sns_topic" "mx_sns_notify_failover" {
#   name = "cpu_alarm_topic"
# }

# resource "aws_sns_topic_subscription" "my_sns_topic_subscription" {
#   topic_arn = aws_sns_topic.mx_sns_notify_failover.arn
#   protocol  = "email"
#   endpoint  = var.email
# }