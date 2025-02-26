###################
## External ALB SG
resource "aws_security_group" "exlb_security_group" {
  name        = "External Load Balancer Server Security Group"
  description = "Enable obia festus"
  vpc_id      = var.vpc_id


  ingress {
      description      = "HTTP ACCESS"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
    }
    ingress   {
      description      = "HTTPS ACCESS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
    }

    ingress {
      description      = "SSH ACCESS"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
    }
  

  egress {
    description = "ssh Connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "External Lbalancer Security Group | Pre Layer"
  }


}


################################
### Web TIER LAYER SG
##############################
### SH APP tier (BASTION HOST)

resource "aws_security_group" "web_security_group" {

  name        = "App Layer SG Access"
  description = "Enable shh on port 22"
  vpc_id      = var.vpc_id


  ingress {
    description = "ssh-access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_instance_1_ip, var.public_instance_2_ip, "0.0.0.0/0"] # it should be your ip addr
    security_groups = [ aws_security_group.exlb_security_group.id, 
        var.public_instance_1_ip, 
        var.public_instance_2_ip]
  }

  ingress {
    description = "HTTP access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ aws_security_group.exlb_security_group.id ]
  }

  ingress {
    description = "HTTPS access"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ aws_security_group.exlb_security_group.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }

  tags = {
    Name = "app Security group"
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
    description = "HTTP ACCESS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [ aws_security_group.web_security_group.id ]
  }


  ingress {
    description = "HTTPs ACCESS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "ssh-access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_instance_1_ip, var.public_instance_2_ip] # it should be your ip addr
    security_groups = [ aws_security_group.exlb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "APp Layer Security Group"
  }
}


#####################
## SG FOR DB TIER
######################
resource "aws_security_group" "database_security_group" {
  name        = "DB SERver Sec Group"
  description = "Enable MYSQL access on port 3306"
  vpc_id      = var.vpc_id


  ingress {
    description     = "MYSQL access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_security_group.id]
    cidr_blocks = [var.private_instance_1_ip, var.private_instance_2_ip]
  }

  tags = {
    Name = "Database Security Group"
  }
}

