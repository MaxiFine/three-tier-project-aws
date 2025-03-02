
##########################
## VARIABLES
##########################
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
  description = "Security group ID for web layer"
  type        = string
}

variable "asg_app_sg" {
  description = "Security group ID for app layer"
  type        = string
}

variable "web_alb_arn" {
  description = "ARN for web ALB target group"
  type        = string
}

variable "app_alb_arn" {
  description = "ARN for app ALB target group"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}