
variable "public_web_subnet_1" {
  description = "The ID of the first public web subnet"
  type        = string
}

variable "public_web_subnet_2" {
  description = "The ID of the second public web subnet"
  type        = string
}

variable "private_app_subnet_1" {
  description = "The ID of the first private app subnet"
  type        = string
}

variable "private_app_subnet_2" {
  description = "The ID of the second private app subnet"
  type        = string
}

variable "web_security_group_id" {
  description = "SG for App Tier"
  type        = string
}
variable "app_security_group_id" {
  description = "SG for App Tier"
  type        = string
}


variable "vpc_id" {
  description = "SG for App Tier"
  type        = string
}
