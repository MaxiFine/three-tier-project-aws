resource "aws_cloudwatch_metric_alarm" "increase_ec2_alarm" {
  alarm_name                = "increase-ec2-alarm"
  # The alarm will trigger if the CPU utilization is greater than or equal
  # to the specified threshold
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  # Number of periods over which the alarm condition must be met to trigger
  # the alarm. It is set to 2, meaning the CPU utilization must remain above
  # the threshold for two consecutive periods
  evaluation_periods        = 2
  # Name of the metric to monitor. Here, it's "CPUUtilization",
  # indicating the CPU utilization metric of EC2 instances
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  # The alarm evaluates CPU utilization data over a period of 120 seconds (2 minutes)
  period                    = 120
  # Average CPU utilization
  statistic                 = "Average"
  # Threshold value that, when crossed, triggers the alarm
  threshold                 = 70
  alarm_description         = "This metric monitors ec2 cpu utilization, if it goes above 70% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []

  # Actions to take when the alarm state changes to "ALARM".
  # When the alarm triggers, it will send notifications to the SNS topic
  # and execute the specified Auto Scaling policy.
  alarm_actions = [
      "${aws_sns_topic.my_sns_topic.arn}",
      "${aws_autoscaling_policy.increase_ec2.arn}"
  ]
}

resource "aws_cloudwatch_metric_alarm" "reduce_ec2_alarm" {
  alarm_name                = "reduce-ec2-alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 40
  alarm_description         = "This metric monitors ec2 cpu utilization, if it goes below 40% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []

  alarm_actions = [
      "${aws_sns_topic.my_sns_topic.arn}",
      "${aws_autoscaling_policy.increase_ec2.arn}"
  ]
}