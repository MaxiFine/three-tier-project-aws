provider "aws" {
  region = "eu-west-1"  # Primary region
}


provider "aws" {
  alias  = "secondary"
  region = "eu-central-1"  # Secondary region
}


resource "aws_route53_health_check" "primary_health_check_http" {
  # fqdn              = "mxdrproject.click"  # Replace with your primary endpoint
  fqdn              = "mxdr.free-sns.live"  # Replace with your primary endpoint
  port              = 80
  type              = "HTTP"
  resource_path     = "/"  # Your health check endpoint
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "Primary-Region-Health-Check"
  }
}

# Failover Record for PRIMARY (Active)
resource "aws_route53_record" "primary_failover" {
  # zone_id = aws_route53_zone.main.zone_id
  zone_id = var.zone_id
  name    = "primary.mxdr.free-sns.live"  # Your domain/subdomain
  type    = "A"
  # ttl     = 60
  # records = [ var.external_alb_dns ]

  set_identifier = "primary-region"

  # Alias to your PRIMARY resource (e.g., ALB in eu-west-1)
  alias {
    # name                   = "dualstack.primary-alb-123456.eu-west-1.elb.amazonaws.com"  # Replace with your ALB DNS
    # zone_id                = "Z1ABC2345XYZ6"  # Replace with ALB's hosted zone ID (eu-west-1 ALB)
    name = var.external_alb_dns
    zone_id = var.external_alb_zone_id
    evaluate_target_health = true
  }

  # Failover Routing Policy
  failover_routing_policy {
    type = "PRIMARY"  # Active
  }

  # Link to Health Check
  # health_check_id = aws_route53_health_check.primary_health_check.id
  health_check_id = "${aws_route53_health_check.primary_health_check_http.id}"
}

# Failover Record for SECONDARY (Passive)
resource "aws_route53_record" "secondary_failover" {
  # zone_id = aws_route53_zone.main.zone_id
  # name    = "recovery.mxdrproject.click"
  zone_id = var.zone_id
  name    = "primary.mxdr.free-sns.live" 
  type    = "A"
  # ttl     = 60

  set_identifier = "secondary-region"

  # Alias to your SECONDARY resource (e.g., ALB in eu-central-1)
  alias {
    # name                   = "dualstack.secondary-alb-789012.eu-central-1.elb.amazonaws.com"  # Replace with your ALB DNS
    name                   = "${var.external_alb_dns}"  # Replace with your ALB DNS
    zone_id                = "${var.external_alb_zone_id}"  # Replace with ALB's hosted zone ID (eu-central-1 ALB)
    evaluate_target_health = true
  }

  # Failover Routing Policy
  failover_routing_policy {
    type = "SECONDARY"  # Passive
  }

  # No direct health check needed; Route 53 auto-fails over if PRIMARY is unhealthy.
}


####################
# # CW TO detect failure
# resource "aws_cloudwatch_event_rule" "failover_trigger" {
#   name        = "failover-trigger"
#   description = "Triggers Lambda on failure detection"

#   event_pattern = <<EOF
# {
#   "source": ["aws.health"],
#   "detail-type": ["AWS Health Event"],
#   "detail": {
#     "service": ["RDS", "EC2"]
#   }
# }
# EOF
# }


###############################
## CW METRIC CHECK

# resource "aws_cloudwatch_metric_alarm" "primary_health_alarm" {
#   alarm_name          = "PrimaryRegionHealthCheckFailed"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "HealthCheckStatus"
#   namespace          = "AWS/Route53"
#   period             = 60
#   statistic          = "Minimum"
#   threshold          = 1
#   alarm_actions      = [var.sns_notify_arn]
# }

#######################
## NEW CW METRIC CHECK
resource "aws_cloudwatch_metric_alarm" "primary_region_failure" {
  provider            = aws
  alarm_name          = "PrimaryRegionFailureAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "Triggers when primary region ALB fails"
  treat_missing_data  = "breaching"

  dimensions = {
    LoadBalancer = var.external_alb_dns  # Replace with your ALB DNS
    # TargetGroup = var.  # Replace with your target group name
  }

  # alarm_actions = [aws_sns_topic.failover_topic.arn]
  alarm_actions = [var.sns_notify_arn]  # SNS topic for notifications
}


########################################
# IAM Role for Lambda Execution
########################################
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Principal = { Service = "lambda.amazonaws.com" },
        Effect    = "Allow"
      }
    ]
  })
}

# Attach a policy that grants sufficient permissions (for demo purposes AdministratorAccess is used;
# in production, please follow least privilege principles)
resource "aws_iam_policy_attachment" "lambda_policy_attach" {
  name       = "lambda_policy_attachment"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#################################
## LAMBDA FUNCTION FOR FAILOVER
resource "aws_lambda_function" "provision_secondary" {
  provider      = aws.secondary
  function_name = "ProvisionSecondaryRegion"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = data.archive_file.lambda_zip.output_path

  environment {
    variables = {
      REPO_URL = "https://github.com/MaxiFine/three-tier-project-aws.git"
      REGION   = "eu-central-1"
    }
  }
  # source_code_hash = filebase64sha256("lambda_function.zip")
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

}


data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.root}/modules/iam/lambda_recovery.py"
  output_path = "${path.module}/route53/lambda.zip"
}
