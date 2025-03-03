variable "db_subnet_1" {
  type        = string
  description = "DB Dec Group 1"
}


variable "db_subnet_2" {
  type        = string
  description = "DB Dec Group 2"
}


variable "db_sec_group_id" {
  type = string
}


variable "db_u_name" {
  default = "mxterradb"
  description = "DB Username"
}

variable "db_pass" {
  default = "maxwell22"
}