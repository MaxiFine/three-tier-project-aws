# ###################
# ## External ALB SG
# resource "aws_security_group" "exlb_security_group" {
#   name        = "External LB Security Group"
#   description = "Enable obia festus"
#   vpc_id      = var.vpc_id


#   ingress {
#     description = "HTTP ACCESS"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     # security_groups  = []
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     self             = false
#   }
#   ingress {
#     description = "HTTPS ACCESS"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     # security_groups  = []
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     self             = false
#   }

#   ingress {
#     description = "SSH ACCESS"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     # security_groups  = []
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     self             = false
#   }


#   egress {
#     description = "outbound Connection"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }


#   tags = {
#     Name = "External Lb Security Group Pre Layer"
#   }


# }


################################
### Web TIER LAYER SG
##############################
### SH APP tier (BASTION HOST)

resource "aws_security_group" "web_security_group" {

  name        = "Web Layer SG Access"
  description = "Enable shh on port 22"
  vpc_id      = var.vpc_id


  ingress {
    description = "ssh-access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["${var.public_instance_1_ip}/32", "${var.public_instance_2_ip}/32"] # it should be your ip addr
    cidr_blocks = ["0.0.0.0/0"] # it should be your ip addr
    # cidr_blocks = ["0.0.0.0/0"] # it should be your ip addr
    # security_groups = [ 
    #     aws_security_group.exlb_security_group.id, 
    #     # aws_security_group.web_security_group.id
    #     # var.public_instance_1_ip, 
    #     # var.public_instance_2_ip
    #     ]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = [ "${var.public_instance_1_ip}/32", "${var.public_instance_2_ip}/32" , "0.0.0.0/0"]
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [
    #     # var.private_instance_1_ip,
    #     # var.private_instance_2_ip
    #     aws_security_group.exlb_security_group.id
    # ]
  }

   ingress {
    description = "HTTP access 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # cidr_blocks = [ "${var.public_instance_1_ip}/32", "${var.public_instance_2_ip}/32" , "0.0.0.0/0"]
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [
    #     # var.private_instance_1_ip,
    #     # var.private_instance_2_ip
    #     aws_security_group.exlb_security_group.id
    # ]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    # cidr_blocks = [ "${var.public_instance_1_ip}/32", "${var.public_instance_2_ip}/32", "0.0.0.0/0" ]
    cidr_blocks     = ["0.0.0.0/0"]
  
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  tags = {
    Name = "PublicWeb Security group"
  }
}

###############################
## ALB SECURITY GROUP
###############
### SG App Load Balancer
###########################

resource "aws_security_group" "app_security_group" {

  name        = "ALB Security Group"
  description = "Enable http/https access on port 80/443"
  vpc_id      = var.vpc_id


  ingress {
    description = "ssh-access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # it should be your ip addr
    # cidr_blocks = ["0.0.0.0/0"] # it should be your ip addr
    security_groups = [
      # aws_security_group.exlb_security_group.id
      # var.public_instance_1_ip, 
      # var.public_instance_2_ip
    ]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [
    #   # var.private_instance_1_ip,
    #   # var.private_instance_2_ip
    #   aws_security_group.web_security_group.id
    # ]
  }

  ingress {
    description     = "HTTPS access"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.web_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }


  tags = {
    Name = "PrivateApp Layer Security Group"
  }
}


#####################
## SG FOR DB TIER
######################
resource "aws_security_group" "database_security_group" {
  name        = "DB Server S"
  description = "Enable MYSQL access on port 3306"
  vpc_id      = var.vpc_id


  ingress {
    description = "MYSQL access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # security_groups = [aws_security_group.app_security_group.id]
    # security_groups = [aws_security_group.app_security_group.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Postgres Access"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    # security_groups = [aws_security_group.app_security_group.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database Security Group"
  }
}

