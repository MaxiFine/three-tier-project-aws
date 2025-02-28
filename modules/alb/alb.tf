

###############
## FIX FOR alb.tf
###########################
# WEB app Load b stuff
resource "aws_lb" "web_external_lb" {
  name               = "Web-external-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_sgroup]
  # subnets                    = [aws_subnet.public-web-subnet-1.id, aws_subnet.public-web-subnet-2.id]
  subnets                    = [var.public_web_subnet_1, var.public_web_subnet_2]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "ALB Web Tier"
  }
}

resource "aws_lb_target_group" "web_attaching_1" {
  name     = "app-balancer"
  port     = 80
  protocol = "HTTP"
  # vpc_id   = aws_vpc.vpc_01.id
  vpc_id = var.vpc_id
  target_type = "instance"
  health_check {
    path = "/"
    protocol = "HTTP"
    port = "trafic-port"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 4
    interval = 5
  }

  tags = {
    Name = "ABL attatch web tier"
  }
}


#####################################
## APPLICATION LOAD BALANCER
resource "aws_lb" "app_internal_lb" {
  name               = "App-internal-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.app_sgroup]
  # subnets                    = [aws_subnet.public-web-subnet-1.id, aws_subnet.public-web-subnet-2.id]
  subnets                    = [var.private_app_subnet_1, var.private_app_subnet_2]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "ALB App Tier"
  }
}

resource "aws_lb_target_group" "app_lb_attaching" {
  name     = "app-balancer"
  port     = 80
  protocol = "HTTP"
  
  # vpc_id   = aws_vpc.vpc_01.id
  vpc_id = var.vpc_id
  target_type = "instance"
  health_check {
    path = "/"
    protocol = "HTTP"
    port = "trafic-port"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 4
    interval = 5
  }

  tags = {
    Name = "ABL attatch App tier"
  }
}

###################
## ALB LISTENER

resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.app_internal_lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_lb_attaching.arn
  }
}


# resource "aws_lb_target_group_attachment" "web_attaching_1" {
#   target_group_arn = aws_lb_target_group.web_attaching_1.arn
#   # target_id        = aws_instance.PublicWebTemplat-1.id
#   target_id = var.public_instance_2
#   port      = 80
# }

# resource "aws_lb_target_group_attachment" "web_attaching_2" {
#   target_group_arn = aws_lb_target_group.web_attaching_1.arn
#   target_id        = var.public_instance_1
#   port             = 80
# }

# ########################################
# ### A LISTENER
# resource "aws_lb_listener" "web_listener" {
#   load_balancer_arn = aws_lb.web_external_lb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = 443
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# ###################################
# ## APPLICATION TIER LOAD BALANCER
# resource "aws_lb" "app_internal_lb" {
#   name               = "App-internal-load-balancer"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [var.app_sgroup]
#   # subnets                    = [aws_subnet.public-web-subnet-1.id, aws_subnet.public-web-subnet-2.id]
#   subnets                    = [var.public_web_subnet_1, var.public_web_subnet_2]
#   enable_deletion_protection = false

#   tags = {
#     Name = "ALBAppTier"
#   }
# }

# resource "aws_lb_target_group" "app_attaching_2" {
#   name     = "app-balancer"
#   port     = 80
#   protocol = "HTTP"
#   # vpc_id   = aws_vpc.vpc_01.id
#   vpc_id = var.vpc_id

#   tags = {
#     Name = "ABL attatch App tier"
#   }
# }

# resource "aws_lb_target_group_attachment" "app_attaching_1" {
#   target_group_arn = aws_lb_target_group.app_attaching_2.arn
#   # target_id        = aws_instance.PublicWebTemplat-1.id
#   target_id = var.public_instance_2
#   port      = 80
# }

# resource "aws_lb_target_group_attachment" "app_attaching_2" {
#   target_group_arn = aws_lb_target_group.app_attaching_2.arn
#   target_id        = var.public_instance_1
#   port             = 80
# }

# ########################################
# ### A LISTENER
# resource "aws_lb_listener" "app_listener" {
#   # load_balancer_arn = aws_lb.web_external_lb.arn
#   load_balancer_arn = aws_lb.app_internal_lb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = 443
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
#   tags = {
#     Name = "App tier alb"
#   }
# }

