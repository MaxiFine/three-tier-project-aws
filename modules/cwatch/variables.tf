variable "sns_topic_arn" {
  type = string
  description = "sns topic arn"
}

variable "web_inc_asg_arn" {
  type = string
  description = "Web asg arn"
}


variable "app_Inc_asg_arn" {
  type = string
  description = "App increase asg arn"
}
variable "app_dcr_asg_arn" {
  type = string
  description = "App Decr asg arn"
}

variable "web_decr_asg" {
  type = string
  description = "WEb decrease policy"
}