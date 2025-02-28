##########################
### WEB SECTIOIN AUTO SCALING GROUP

resource "aws_cloudwatch_metric_alarm" "web_increase_ec2_alarm" {
  alarm_name                = "web-increase-ec2-alarm"
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
  alarm_description         = "This metric monitors web ec2 cpu utilization, if it goes above 70% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []

  # Actions to take when the alarm state changes to "ALARM".
  # When the alarm triggers, it will send notifications to the SNS topic
  # and execute the specified Auto Scaling policy.
  alarm_actions = [
        var.sns_topic_arn,
        var.web_inc_asg_arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "web_reduce_ec2_alarm" {
  alarm_name                = "web-reduce-ec2-alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 40
  alarm_description         = "This metric monitors web ec2 cpu utilization, if it goes below 40% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []

  alarm_actions = [
        var.sns_topic_arn,
        var.web_decr_asg
  ]
}


#############################
## APP SECTION AUTO SCALING
resource "aws_cloudwatch_metric_alarm" "app_increase_ec2_alarm" {
  alarm_name                = "app_increase-ec2-alarm"
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
  alarm_description         = "This metric monitors app ec2 cpu utilization, if it goes above 70% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []

  # Actions to take when the alarm state changes to "ALARM".
  # When the alarm triggers, it will send notifications to the SNS topic
  # and execute the specified Auto Scaling policy.
  alarm_actions = [
        var.sns_topic_arn,
        var.app_Inc_asg_arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "app_reduce_ec2_alarm" {
  alarm_name                = "app_reduce-ec2-alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 40
  alarm_description         = "This metric monitors app ec2 cpu utilization, if it goes below 40% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []

  alarm_actions = [
        var.sns_topic_arn,
        var.app_dcr_asg_arn
  ]
}

