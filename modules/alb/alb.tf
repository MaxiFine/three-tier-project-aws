provider "aws" {
  region = "eu-west-1"  # Primary region
}


# provider "aws" {
#   alias  = "secondary"
#   region = "eu-central-1"  # Secondary region
# }

# ###############
# ## FAILOVER FOR alb.tf
# ###########################
# # WEB app Load b stuff
# resource "aws_lb" "failover_alb" {
#   name               = "failover-load-balancer"
#   provider = aws.secondary  # to be provisioned in secondary region
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [var.web_sgroup]
#   # subnets                    = [aws_subnet.public-web-subnet-1.id, aws_subnet.public-web-subnet-2.id]
#   subnets                          = [var.public_web_subnet_1, var.public_web_subnet_2]
#   enable_deletion_protection       = false
#   enable_cross_zone_load_balancing = true

#   tags = {
#     Name = "ALB Web Tier"
#   }
# }

# ###################
# ## FAILOVER ALB LISTENER
# resource "aws_lb_listener" "failover_alb_listener" {
#   load_balancer_arn = aws_lb.web_external_lb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     # target_group_arn = aws_lb_target_group.app_lb_attaching.arn
#     target_group_arn = aws_lb_target_group.web_external_tgroup.arn
#   }
# }


# #############################
# ## FAILOVER ALB TARGET GROUP
# resource "aws_lb_target_group" "failover_tgroup" {
#   name     = "failover-load-balancer-tg"
#   port     = 80
#   protocol = "HTTP"
#   # vpc_id   = aws_vpc.vpc_01.id
#   vpc_id      = var.vpc_id
#   target_type = "instance"
#   health_check {
#     path                = "/"
#     protocol            = "HTTP"
#     port                = "traffic-port"
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 4
#     interval            = 5
#   }

#   tags = {
#     Name = "FAILOVER ALB"
#   }
# }



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
  subnets                          = [var.public_web_subnet_1, var.public_web_subnet_2]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "ALB Web Tier"
  }
}

###################
## WEB ALB LISTENER
resource "aws_lb_listener" "web_alb_listener" {
  load_balancer_arn = aws_lb.web_external_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    # target_group_arn = aws_lb_target_group.app_lb_attaching.arn
    target_group_arn = aws_lb_target_group.web_external_tgroup.arn
  }
}


#############################
## WEB TARGET GROUP
resource "aws_lb_target_group" "web_external_tgroup" {
  name     = "Web-load-balancer-tg"
  port     = 80
  protocol = "HTTP"
  # vpc_id   = aws_vpc.vpc_01.id
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 4
    interval            = 5
  }

  tags = {
    Name = "ABL attatch web tier"
  }
}



#####################################
## APPLICATION LOAD BALANCER
resource "aws_lb" "app_internal_lb" {
  name               = "App-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.app_sgroup]
  # subnets                    = [aws_subnet.public-web-subnet-1.id, aws_subnet.public-web-subnet-2.id]
  subnets                          = [var.private_app_subnet_1, var.private_app_subnet_2]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "ALB App Tier"
  }
}

resource "aws_lb_target_group" "app_internal_tgroup" {
  name     = "App-internal-load-balancer-tg"
  port     = 80
  protocol = "HTTP"

  # vpc_id   = aws_vpc.vpc_01.id
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 4
    interval            = 5
  }

  tags = {
    Name = "ABL attatch App tier"
  }
}

###################
## ALB LISTENER
resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.app_internal_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_internal_tgroup.arn
  }
}

