# variable "app_layer_sg_id" {
#   description = "App SG"
#   type = string
# }
variable "vpc_id" {
  description = "App SG"
  type = string
}
# variable "web_layer_sg_id" {
#   description = "App SG"
#   type = string
# }
# variable "db_layer_sg_id" {
#   description = "App SG"
# #   type = list()
#   type = string
# }

variable "public_instance_1_ip" {
    type = string
    description = "Private 1 ec2 id"
  
}
variable "public_instance_2_ip" {
    type = string
    description = "Private 2 ec2 id" 
}
variable "private_instance_1_ip" {
    type = string
    description = "Private 1 ec2 id"
  
}
variable "private_instance_2_ip" {
    type = string
    description = "Private 2 ec2 id" 
}


# variable "webserver_security_group  " {
#   type = string
#   description = "WEB Tier SG"
# }
# variable "app_security_group  " {
#   type = string
#   description = "App Tier SG"
# }
# variable "db_security_group  " {
#   type = string
#   description = "DB Tier SG"
# }