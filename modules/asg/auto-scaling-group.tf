#######################################
########### WEB LAYER ASG TEMPLATES ###
#######################################
# Define a launch template
resource "aws_launch_template" "web_asg_template" {
  name_prefix = "web_launch_template_"
  # image_id = "ami-0322211ccfe5b6a20" # Ubuntu 20.04, eu-west-3
  # image_id               = "ami-05865e6b3e86cd438"
  image_id               = "ami-03fd334507439f4d1"
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [var.asg_web_sg]
  # user_data              = filebase64("u_data.sh")
  user_data = filebase64("${path.root}/user_data.sh")
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "web-tier-asg-pub-instance"
  }
}


resource "aws_autoscaling_group" "web_asg" {
  vpc_zone_identifier = [var.public_subnet_1_cidr, var.public_subnet_2_cidr]
  min_size = 1
  max_size = 2
  desired_capacity = 1
  health_check_grace_period = 150
  health_check_type = "ELB"


  # Associate with ALB target group
  # target_group_arns = [aws_lb_target_group.my_target_group.arn]
  # target_group_arns = aws_launch_template.web_asg_template.
  target_group_arns = [var.web_alb_arn]

  tag {
    key                 = "Name"
    value               = "Web-ASG-instance"
    propagate_at_launch = true
  }

  # Specify the launch template defined before
  launch_template {
    # id = aws_launch_template.my_launch_template.id
    id      = aws_launch_template.web_asg_template.id
    version = "$Latest"
  }
}


resource "aws_autoscaling_policy" "web_increase_ec2_policy" {
  name               = "WebIncreaseEc2"
  scaling_adjustment = 1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 200
  # autoscaling_group_name = aws_autoscaling_group.my_asg.name
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "SimpleScaling"

}


resource "aws_autoscaling_policy" "web_reduce_ec2_policy" {
  name               = "reduce-ec2"
  scaling_adjustment = -1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 300
  # autoscaling_group_name = aws_autoscaling_group.my_asg.name
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "SimpleScaling"

  
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
  name_prefix = "app_asg_template"
  # image_id = "ami-0322211ccfe5b6a20" # Ubuntu 20.04, eu-west-3
  # image_id               = "ami-0a9c85f551385c96d"
  image_id               = "ami-05865e6b3e86cd438"
  # image_id               = "ami-03fd334507439f4d1"
  instance_type          = "t3.micro"
  # key_name               = "vagrant-key"
  key_name               = var.key_name
  # vpc_security_group_ids = [var.asg_web_sg]
  vpc_security_group_ids = [var.asg_app_sg]
  # user_data              = filebase64("u_data.sh")
  user_data = filebase64("${path.root}/user_data.sh")
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "app-asg-private-instance"
  }
}



resource "aws_autoscaling_group" "app_asg" {
  # vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
  vpc_zone_identifier = [var.private_subnet_1_cidr, var.private_subnet_2_cidr]
  min_size = 1
  # Maximum number of instances the Auto Scaling group can scale up to
  max_size = 2
  desired_capacity = 1
  # target_group_arns = [aws_lb_target_group.my_target_group.arn]
  health_check_grace_period = 150
  health_check_type = "ELB"
  # target_group_arns = [var.app_alb_arn]

  tag {
    key                 = "Name"
    value               = "APP-ASG-instance"
    propagate_at_launch = true
  }

  # Specify the launch template defined before
  launch_template {
    # id = aws_launch_template.my_launch_template.id
    id      = aws_launch_template.app_asg_template.id
    version = "$Latest"
  }
}


resource "aws_autoscaling_policy" "app_increase_ec2_policy" {
  name               = "AppIncreaseEc2"
  scaling_adjustment = 1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 300
  # autoscaling_group_name = aws_autoscaling_group.my_asg.name
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  policy_type            = "SimpleScaling"

}

# Policy that decreases the number of instances by 1 when triggered,
# also using the "SimpleScaling" policy type.
resource "aws_autoscaling_policy" "app_reduce_ec2_policy" {
  name               = "app-reduce-ec2"
  scaling_adjustment = -1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 120
  # autoscaling_group_name = aws_autoscaling_group.my_asg.name
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  policy_type            = "SimpleScaling"
}

# Attach the Auto Scaling Group to the ALB target group
resource "aws_autoscaling_attachment" "app_asg_attachment" {
  # autoscaling_group_name = aws_autoscaling_group.my_asg.id
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  # lb_target_group_arn = aws_lb_target_group.my_target_group.arn
  lb_target_group_arn = var.app_alb_arn
}

