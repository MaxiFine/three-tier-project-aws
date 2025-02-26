variable "cidr_block" {
  default     = "10.0.0.0/16"
  description = "MAIN VPC CIDR"
}

variable "ssh_locate" {
  default     = "instance_IP"
  description = "ip address"

}

variable "database_instance_class" {
  default     = "db.t2.micro"
  description = ""
}

variable "multi_az_deployment" {
  default     = true
  description = "Create a standby Instgance"
  type        = bool

}

# should specify optional vs required

variable "instance_name" {
  description = "Name of ec2 instance"
  type        = string
  default     = "mx-instance"
}

variable "ami" {
  description = "Amazon machine image to use for ec2 instance"
  type        = string
  # default     = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
  default = "ami-03fd334507439f4d1" # Ubuntu 20.04 LTS // us-east-1
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}



variable "aws_region" {
  description = "aws Region"
  type        = string
  default     = "eu-west-1"

}


# variables.tf (root directory)
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16" # Optional: Set a default value
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.4.0/24"
}
variable "db_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.5.0/24"
}

variable "db_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.6.0/24"
}

