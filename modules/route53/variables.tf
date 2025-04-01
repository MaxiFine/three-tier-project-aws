# # variable "zone_id" {
# #   description = "Zone Id of route53"
# #   type = string
# # }

# # variable "zone_name" {
# #   description = "Zone name"
# #   type = string
# # }

# variable "domain_name" {
# description = "Domain name registered for Application"
# # default = "mxdrproject.com"
# type = string
# }

# variable "comment" {
# description = "Comment added in hosted zone"  
# default =     "Route53 for AWS Application"
# type = string
# }

# variable "ttl" {
# description = "TTL of Record"
# default = "10"
# type = string
# }

# variable "primaryhealthcheck" {
# description = "Tag Name for Primary Instance Health Check"
# default = "route53-primary-health-check"
# type = string
# }

# variable "secondaryhealthcheck" {
# description = "Tag Name for Secondary Instance Health Check"
# default = "route53-secondary-health-check"
# type = string
# }

# variable "subdomain" {
# description = "Sub Domain name to access Application"
# default = "testmxdrproject.com"
# type = string
# }

# variable "identifier1" {
#     description = "Primary region"
#     default = "primary"
#     type = string
# }

# variable "identifier2" {
#     description = "Secondary Region"
#     default = "secondary"
#     type = string
# }

# variable "primaryip1" {
#     description = "instance IP after creation"
#     type = string

# }
# variable "primaryip2" {
#     description = "Instance IP after creation"
#     type = string
# }

# variable "secondaryip1" {
#     description = "IP of secondary region"
#     type = string
# }
# # variable "secondaryip2" {
# #     description = "IP of secondary region"
# # }

variable "external_alb_dns" {
  description = "External ALB dns"
}

variable "external_alb_zone_id" {
  description = "External ALB zone id"
}

# variable "web_record_1" {
#   description = "Public Record 1"
# }
# variable "web_record_2" {
#   description = "Public Record 2"
# }

variable "sns_notify_arn" {
  description = "SNS topic for notify"
}

variable "zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
  default     = "Z04817493R2Y2FEP3UF7R" # Replace with your actual hosted zone ID
  
}