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

variable "web_alb_arn" {
  type = string
  description = "Web Alb id"
}


variable "app_alb_arn" {
  type = string
  description = "APP alb arn"
}

variable "key_name" {
  type = string
  description = "Key pair name"
}

