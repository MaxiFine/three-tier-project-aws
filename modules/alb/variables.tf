variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

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

variable "web_sgroup" {
  description = "The ID for external alb"
  type        = string
}
variable "app_sgroup" {
  description = "The ID for external alb"
  type        = string
}


# variable "public_instance_1" {
#   description = "Public instance 1 id"
#   type        = string
# }
# # variable "public_instance_2" {
# #   description = " Public Instance 2 id"
# # }


# variable "private_instance_1" {
#   description = "Private instance 1 id"
#   type        = string
# }
# variable "private_instance_2" {
#   description = " Private Instance 2 id"
# }



