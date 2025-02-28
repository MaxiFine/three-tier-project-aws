# ###########################
# ##### ASG for Presentation tier
# resource "aws_launch_template" "public-auto-scaling-group" {
#   # name = "external-asg"
#   name          = "pulic-auto-scaling-group"
#   # image_id      = "ami-03fd334507439f4d1"
#   image_id      = "ami-0a9c85f551385c96d"
#   instance_type = "t2.micro"
#   # user_data     = base64encode(file("${path.module}/user_data.sh"))
#   #  user_data = base64encode(data.templatefile.user_data.rendered)
#   # user_data     = base64encode(file("c/Users/MaxwellAdomako/Desktop/projs/user_data.sh"))
#   # user_data = filebase64(templatefile("${path.root}/user_data.sh", {}))
#   # security_group_names = [var.asg_web_sg]
#   vpc_security_group_ids = [var.asg_web_sg]


#   key_name = "vagrant-key"

#   # network_interfaces {
#   #   subnet_id       = aws_subnet.public-web-subnet-1.id
#   #   security_groups = [aws_security_group.webserver-security-group.id]
#   # }



# }


# resource "aws_autoscaling_group" "asg-1" {
#   # Instead of "availability_zones", use "vpc_zone_identifier"
#   vpc_zone_identifier = [

#     # aws_subnet.private-app-subnet-1.id,
#     # aws_subnet.private-app-subnet-2.id,
#     var.public_subnet_1_cidr,
#     var.public_subnet_2_cidr
#   ]
#   desired_capacity = 1
#   max_size         = 2
#   min_size         = 1
  

#   launch_template {
#     id      = aws_launch_template.auto-scaling-group-private.id
#     version = "$Latest"
#   }
# }

# #########################
# ## AS GROUP for APP tier
# #########################
# resource "aws_launch_template" "auto-scaling-group-private" {
#   # name = "internal-asg"
#   name_prefix   = "private-auto-scaling-group"
#   # image_id      = "ami-03fd334507439f4d1"
#   image_id      = "ami-05865e6b3e86cd438"
#   instance_type = "t2.micro"
#   key_name      = "vagrant-key"
#   # Remove network_interfaces block so that subnets are provided by the ASG
#   # user_data     = base64encode(file("${path.module}/user_data.sh"))
#   # user_data = base64encode(data.templatefile.user_data.rendered)
#   # user_data     = base64encode(file("${c/Users/MaxwellAdomako/Desktop/projs}/user_data.sh", {}))
#   # user_data = base64encode(file("c:/Users/MaxwellAdomako/Desktop/projs/user_data.sh"))
#   # user_data = base64encode(templatefile("${path.root}/user_data.sh", {}))
#   security_group_names = [ var.asg_app_sg ]
#   user_data =  <<-EOF
#               #!/bin/bash
#               echo "Hello, World 1" > index.html
#               python3 -m http.server 8080 &
#               EOF
#   # user_data = <<-E0F EOF



# }

# resource "aws_autoscaling_group" "asg-2" {
#   # Instead of "availability_zones", use "vpc_zone_identifier"
#   vpc_zone_identifier = [
#     # aws_subnet.private-app-subnet-1.id,
#     # aws_subnet.private-app-subnet-2.id,
#     var.private_subnet_1_cidr,
#     var.private_subnet_2_cidr
#   ]

#   desired_capacity = 1
#   max_size         = 2
#   min_size         = 1

#   launch_template {
#     id      = aws_launch_template.auto-scaling-group-private.id
#     version = "$Latest"
#   }
# }


#######################################
########### WEB LAYER ASG TEMPLATES ###
#######################################
# Define a launch template
resource "aws_launch_template" "web_asg_template" {
    name_prefix = "my_launch_template_"
    # image_id = "ami-0322211ccfe5b6a20" # Ubuntu 20.04, eu-west-3
    image_id = "ami-05865e6b3e86cd438"
    instance_type = "t2.micro"
    key_name = "TF_Key"
    vpc_security_group_ids = [ var.asg_web_sg ]
    user_data = filebase64("u_data.sh")
}

# Generate an RSA private key
resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits = 4096
}

# Define an AWS key pair resource named "TF_key".
# It creates an SSH key pair where the public key is derived
# from the RSA private key generated in the previous block.
# This key pair can be used to authenticate with EC2 instances launched in AWS.
resource "aws_key_pair" "TF_key" {
    key_name = "TF_key"
    public_key = tls_private_key.rsa.public_key_openssh
}

# Defines a local file resource named "private_key".
# It writes the content of the RSA private key generated in
# the first block to a file named "tfkey" on the local filesystem.
resource "local_file" "private_key" {
    content = tls_private_key.rsa.private_key_pem
    filename = "tfkey"
}

resource "aws_autoscaling_group" "web_asg" {
    # vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
    vpc_zone_identifier = [var.public_subnet_1_cidr, var.public_subnet_2_cidr]
    
    # Minimum number of instances the Auto Scaling group should maintain. 
    min_size = 1

    # Maximum number of instances the Auto Scaling group can scale up to
    max_size = 2

    # Specifies the desired number of instances that the Auto Scaling group
    # should maintain. It is set to 1, which means the Auto Scaling group will
    # initially launch and maintain one instance.
    desired_capacity = 1

    # Associate with ALB target group
    # target_group_arns = [aws_lb_target_group.my_target_group.arn]
    target_group_arns = [var.web_alb_arn]

    tag {
        key = "Name"
        value = "Web ASG"
        propagate_at_launch = true
    }

    # Specify the launch template defined before
    launch_template {
        # id = aws_launch_template.my_launch_template.id
        id = aws_launch_template.web_asg_template.id
        version = "$Latest"
    }
}

# Policy that increases the number of instances by 1 when triggered.
# This policy type is "SimpleScaling", meaning it directly adjusts
# the desired capacity of the Auto Scaling group.
resource "aws_autoscaling_policy" "web_increase_ec2_policy" {
    name                   = "WebIncreaseEc2"
    scaling_adjustment     = 1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    # autoscaling_group_name = aws_autoscaling_group.my_asg.name
    autoscaling_group_name = aws_autoscaling_group.web_asg.name
    policy_type = "SimpleScaling"
    
}

# Policy that decreases the number of instances by 1 when triggered,
# also using the "SimpleScaling" policy type.
resource "aws_autoscaling_policy" "web_reduce_ec2_policy" {
    name                   = "reduce-ec2"
    scaling_adjustment     = -1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    # autoscaling_group_name = aws_autoscaling_group.my_asg.name
    autoscaling_group_name = aws_autoscaling_group.web_asg.name
    policy_type = "SimpleScaling"
}

# Attach the Auto Scaling Group to the ALB target group
resource "aws_autoscaling_attachment" "web_asg_attachment" {
    # autoscaling_group_name = aws_autoscaling_group.my_asg.id
    autoscaling_group_name = aws_autoscaling_group.web_asg.id
    # lb_target_group_arn = aws_lb_target_group.my_target_group.arn
    lb_target_group_arn = var.web_alb_arn
}





####################################
## APP LAYER ASG TEMPLATE TO USE
####################################
resource "aws_launch_template" "app_asg_template" {
    name_prefix = "my_launch_template_"
    # image_id = "ami-0322211ccfe5b6a20" # Ubuntu 20.04, eu-west-3
    image_id = "ami-0a9c85f551385c96d"
    instance_type = "t2.micro"
    key_name = "TF_Key"
    vpc_security_group_ids = [ var.asg_web_sg ]
    user_data = filebase64("u_data.sh")
}


# # Generate an RSA private key
# resource "tls_private_key" "rsa" {
#     algorithm = "RSA"
#     rsa_bits = 4096
# }

# # Define an AWS key pair resource named "TF_key".
# # It creates an SSH key pair where the public key is derived
# # from the RSA private key generated in the previous block.
# # This key pair can be used to authenticate with EC2 instances launched in AWS.
# resource "aws_key_pair" "TF_key" {
#     key_name = "TF_key"
#     public_key = tls_private_key.rsa.public_key_openssh
# }

# # Defines a local file resource named "private_key".
# # It writes the content of the RSA private key generated in
# # the first block to a file named "tfkey" on the local filesystem.
# resource "local_file" "private_key" {
#     content = tls_private_key.rsa.private_key_pem
#     filename = "tfkey"
# }

resource "aws_autoscaling_group" "app_asg" {
    # vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
    vpc_zone_identifier = [var.private_subnet_1_cidr, var.private_subnet_2_cidr]
    
    # Minimum number of instances the Auto Scaling group should maintain. 
    min_size = 1

    # Maximum number of instances the Auto Scaling group can scale up to
    max_size = 2

    # Specifies the desired number of instances that the Auto Scaling group
    # should maintain. It is set to 1, which means the Auto Scaling group will
    # initially launch and maintain one instance.
    desired_capacity = 1

    # Associate with ALB target group
    # target_group_arns = [aws_lb_target_group.my_target_group.arn]
    target_group_arns = [var.app_alb_arn]

    tag {
        key = "Name"
        value = "APP ASG"
        propagate_at_launch = true
    }

    # Specify the launch template defined before
    launch_template {
        # id = aws_launch_template.my_launch_template.id
        id = aws_launch_template.app_asg_template.id
        version = "$Latest"
    }
}

# Policy that increases the number of instances by 1 when triggered.
# This policy type is "SimpleScaling", meaning it directly adjusts
# the desired capacity of the Auto Scaling group.
resource "aws_autoscaling_policy" "app_increase_ec2_policy" {
    name                   = "AppIncreaseEc2"
    scaling_adjustment     = 1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    # autoscaling_group_name = aws_autoscaling_group.my_asg.name
    autoscaling_group_name = aws_autoscaling_group.app_asg.name
    policy_type = "SimpleScaling"
    
}

# Policy that decreases the number of instances by 1 when triggered,
# also using the "SimpleScaling" policy type.
resource "aws_autoscaling_policy" "app_reduce_ec2_policy" {
    name                   = "reduce-ec2"
    scaling_adjustment     = -1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    # autoscaling_group_name = aws_autoscaling_group.my_asg.name
    autoscaling_group_name = aws_autoscaling_group.app_asg.name
    policy_type = "SimpleScaling"
}

# Attach the Auto Scaling Group to the ALB target group
resource "aws_autoscaling_attachment" "app_asg_attachment" {
    # autoscaling_group_name = aws_autoscaling_group.my_asg.id
    autoscaling_group_name = aws_autoscaling_group.app_asg.id
    # lb_target_group_arn = aws_lb_target_group.my_target_group.arn
    lb_target_group_arn = var.app_alb_arn
}

