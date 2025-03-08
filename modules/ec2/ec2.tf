# ####################
# ### EC2 WEB TIER instances

# data "index_file" "user_data" {
#   template = file("${path.module}/user_data.sh")
# }

resource "aws_instance" "PublicWebTemplat-1" {
  ami           = "ami-03fd334507439f4d1" # Replace with your AMI ID
  instance_type = "t2.micro"
  # subnet_id     = aws_subnet.public-web-subnet-1.id
  subnet_id = var.public_web_subnet_1
  key_name = "vagrant-key"
  # security_groups = [ var.web_security_group ]
  vpc_security_group_ids = [var.web_security_group_id]
  # vpc_security_group_ids = []

  user_data = file("${path.root}/user_data.sh")
  # security_groups = [var.web_security_group]
  tags = {
    Name = "PublicWebTemplat-1"
  }
}

resource "aws_instance" "PublicWebTemplate-2" {
  ami           = "ami-03fd334507439f4d1" # Replace with your AMI ID
  instance_type = "t2.micro"
  # subnet_id     = aws_subnet.public-web-subnet-2.id
  # subnet_id = var.public_web_subnet_2
  subnet_id = var.public_web_subnet_2
  # security_groups = [ var.web_security_group ]
  # vpc_security_group_ids = [ var.web_security_group ]
  vpc_security_group_ids = [ var.web_security_group_id ]
  # security_groups = [var.web_security_group]
  key_name = "vagrant-key"

  user_data = file("${path.root}/user_data.sh")
 
  tags = {
    Name = "PublicWebTemplate-2"
  }
}



# ADD APP TIER INSTANCES
resource "aws_instance" "PrivateAppTemplat-1" {
  ami           = "ami-03fd334507439f4d1" # Replace with your AMI ID
  instance_type = "t2.micro"
  # subnet_id     = aws_subnet.private-app-subnet-1.id
  subnet_id = var.private_app_subnet_1
  # security_groups = [ var.app_security_group ]
  vpc_security_group_ids = [ var.app_security_group_id ]
  # security_groups = [var.app_security_group_id]
  key_name = "vagrant-key"
  user_data = file("${path.root}/user_data.sh")

  tags = {
    Name = "PrivateAppTemplat-1"
  }
}

resource "aws_instance" "PrivateAppTemplate-2" {
  ami           = "ami-03fd334507439f4d1" # Replace with your AMI ID
  instance_type = "t2.micro"
  # subnet_id     = aws_subnet.private-app-subnet-2.id
  subnet_id = var.private_app_subnet_2
  # security_groups = [ var.app_security_group ]
  vpc_security_group_ids = [ var.app_security_group_id]
  # vpc_security_group_ids = []
  key_name = "vagrant-key"
  # security_groups = [var.app_security_group]

  # user_data = base64encode(data.index_file.user_data.rendered)
  # user_data     = base64encode(templatefile("${path.module}/user_data.sh", {}))
  user_data = file("${path.root}/user_data.sh")

  tags = {
    Name = "PrivateAppTemplate-2"
  }
}