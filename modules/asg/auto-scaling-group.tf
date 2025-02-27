###########################
##### ASG for Presentation tier


# Read the user data script from the file

resource "aws_launch_template" "public-auto-scaling-group" {
  # name = "external-asg"
  name   = "pulic-auto-scaling-group"
  image_id      = "ami-03fd334507439f4d1"
  instance_type = "t2.micro"
  # user_data     = base64encode(file("${path.module}/user_data.sh"))
  #  user_data = base64encode(data.templatefile.user_data.rendered)
  # user_data     = base64encode(file("c/Users/MaxwellAdomako/Desktop/projs/user_data.sh"))
  user_data = base64encode(templatefile("${path.root}/user_data.sh", {}))


  key_name      = "vagrant-key"

  # network_interfaces {
  #   subnet_id       = aws_subnet.public-web-subnet-1.id
  #   security_groups = [aws_security_group.webserver-security-group.id]
  # }

  

}

# data "templatefile" "user_data" {
#   template = file("${path.module}/user_data.sh")
# }

# resource "aws_autoscaling_group" "asg-1" {
#   availability_zones = ["eu-west-1a", "eu-west-1b"]
#   desired_capacity   = 1
#   max_size           = 2
#   min_size           = 1


#   launch_template {
#     id      = aws_launch_template.auto-scaling-group.id
#     version = "$Latest"
#   }
# }

resource "aws_autoscaling_group" "asg-1" {
  # Instead of "availability_zones", use "vpc_zone_identifier"
  vpc_zone_identifier = [

    # aws_subnet.private-app-subnet-1.id,
    # aws_subnet.private-app-subnet-2.id,
    var.public_subnet_1_cidr,
    var.public_subnet_2_cidr
  ]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.auto-scaling-group-private.id
    version = "$Latest"
  }
}

#########################
## AS GROUP for APP tier
#########################
# resource "aws_launch_template" "auto-scaling-group-private" {
#   name_prefix   = "auto-scaling-group-private"
#   image_id      = "ami-03fd334507439f4d1"
#   instance_type = "t2.micro"
#   key_name      = "source_key"
#   user_data     = base64encode(file("install-apache.sh"))


#   network_interfaces {
#     subnet_id       = aws_subnet.private-app-subnet-1.id
#     security_groups = [aws_security_group.ssh-security-group.id]
#   }
# }


# resource "aws_autoscaling_group" "asg-2" {
#   availability_zones = ["eu-west-1a", "eu-west-1b"]
#   desired_capacity   = 1
#   max_size           = 2
#   min_size           = 1

#   launch_template {
#     id      = aws_launch_template.auto-scaling-group-private.id
#     version = "$Latest"
#   }
# }

resource "aws_launch_template" "auto-scaling-group-private" {
  # name = "internal-asg"
  name_prefix   = "private-auto-scaling-group"
  image_id      = "ami-03fd334507439f4d1"
  instance_type = "t2.micro"
  key_name      = "vagrant-key"
  # Remove network_interfaces block so that subnets are provided by the ASG
  # user_data     = base64encode(file("${path.module}/user_data.sh"))
  # user_data = base64encode(data.templatefile.user_data.rendered)
  # user_data     = base64encode(file("${c/Users/MaxwellAdomako/Desktop/projs}/user_data.sh", {}))
  # user_data = base64encode(file("c:/Users/MaxwellAdomako/Desktop/projs/user_data.sh"))
  user_data = base64encode(templatefile("${path.root}/user_data.sh", {}))



}

resource "aws_autoscaling_group" "asg-2" {
  # Instead of "availability_zones", use "vpc_zone_identifier"
  vpc_zone_identifier = [
    # aws_subnet.private-app-subnet-1.id,
    # aws_subnet.private-app-subnet-2.id,
    var.private_subnet_1_cidr,
    var.private_subnet_2_cidr
  ]
  
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.auto-scaling-group-private.id
    version = "$Latest"
  }
}
