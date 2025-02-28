# variables.tf (root directory)
# variable "vpc_cidr" {
#   description = "CIDR block for the VPC"
#   type        = string
#   default     = "10.0.0.0/16" # Optional: Set a default value
# }

# variable "public_subnet_1_cidr" {
#   description = "CIDR block for the first public subnet"
#   type        = string
#   default     = "10.0.1.0/24"
# }

# variable "public_subnet_2_cidr" {
#   description = "CIDR block for the second public subnet"
#   type        = string
#   default     = "10.0.2.0/24"
# }

# variable "private_subnet_1_cidr" {
#   description = "CIDR block for the first private subnet"
#   type        = string
#   default     = "10.0.3.0/24"
# }

# variable "private_subnet_2_cidr" {
#   description = "CIDR block for the second private subnet"
#   type        = string
#   default     = "10.0.4.0/24"
# }
# variable "db_subnet_1_cidr" {
#   description = "CIDR block for the first private subnet"
#   type        = string
#   default     = "10.0.5.0/24"
# }

# variable "sb_subnet_2_cidr" {
#   description = "CIDR block for the second private subnet"
#   type        = string
#   default     = "10.0.6.0/24"
# }

##########################
## DYNAMICALLY SETTING THE VARIABLES TO BE USE ACCROSS MODULES


variable "vpc_id" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}


variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
}


variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
}

variable "asg_web_sg" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "asg_app_sg" {
  description = "CIDR block for the second private subnet"
  type        = string
}

# variable "web_alb_id" {
#   type = string
#   description = "Web Alb id"
# }
variable "web_alb_arn" {
  type = string
  description = "Web ALb arn"
}
variable "app_alb_arn" {
  type = string
  description = "APP alb id"
}
# variable "app_alb_id" {
#   type = string
#   description = "APP alb arn"
# }