##########################
## DYNAMICALLY SETTING THE VARIABLES TO BE USE ACCROSS MODULES

# modules/vpc/variables.tf
variable "vpc_cidr" {
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
variable "db_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "db_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
}