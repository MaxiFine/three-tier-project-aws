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