# --------------------------
# Providers and Data
# --------------------------
provider "aws" {
  region = "eu-west-1"  # Use your primary region or where Route53 is managed
}

data "aws_caller_identity" "current" {}

# resource "aws_route53_zone" "main" {
#   name = "mxdrproject.click"
# }

# --------------------------
# IAM Role for Lambda Function
# --------------------------
resource "aws_iam_role" "lambda_dns_failover_role" {
  name = "lambda-dns-failover-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_dns_failover_policy" {
  name = "lambda-dns-failover-policy"
  role = aws_iam_role.lambda_dns_failover_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow CloudWatch logging
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
      # Allow updating Route53 records
      {
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:GetHostedZone"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# --------------------------
# Lambda Function for DNS Failover
# --------------------------
resource "aws_lambda_function" "dns_failover" {
  function_name = "dns_failover_function"
#   filename      = "lambda_function.zip"  # Ensure this ZIP file is available locally
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_dns_failover_role.arn

  environment {
    variables = {
    #   HOSTED_ZONE_ID    = aws_route53_zone.main.zone_id
      HOSTED_ZONE_ID    = var.main_zone_id
    #   RECORD_NAME       = "app.mxdrproject.click"         # Change to your record name
      RECORD_NAME       = var.record_name       # Change to your record name
      SECONDARY_TARGET  = "secondary.example.com"           # Replace with your secondary resource DNS name
      SECONDARY_ZONE_ID = "Z3P5QSUBK4POTI"                   # Replace with your secondary resource's hosted zone ID
    }
  }
}

# --------------------------
# CloudWatch Event Rule to Trigger Lambda on Alarm
# --------------------------
resource "aws_cloudwatch_event_rule" "failover_rule" {
  name        = "failover-trigger"
  description = "Triggers DNS failover when primary health check fails"
  event_pattern = jsonencode({
    "source": [
      "aws.cloudwatch"
    ],
    "detail-type": [
      "CloudWatch Alarm State Change"
    ],
    "detail": {
      "state": {
        "value": ["ALARM"]
      },
      "configuration": {
        "metrics": {
          "metricName": ["HealthCheckStatus"]
        }
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "failover_target" {
  rule      = aws_cloudwatch_event_rule.failover_rule.name
  target_id = "DNSFailoverFunction"
  arn       = aws_lambda_function.dns_failover.arn
}

# Allow CloudWatch Events to invoke the Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dns_failover.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.failover_rule.arn
}

# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "${path.module}/iam/lambda_recovery.py"
#   output_path = "${path.module}/lambda.zip"
# }

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_recovery.py"
  output_path = "${path.module}/lambda.zip"
}
