# output "lb_dns_name" {
#   description = "DNS name of the load balancer"
#   value       = aws_lb.application-load-balancer.arn

# }

# output "aws_instance_web_1" {
#   value = aws_instance.PublicWebTemplat-1.id
# }
# output "aws_instance_web_2" {
#   value = aws_instance.PublicWebTemplate-2.id
# }
# output "aws_instance_app_1" {
#   value = aws_instance
# }
# output "aws_instance_app_2" {
#   value = aws_instance.PublicWebTemplat-1.id
# }



output "vpc_id" {
  #   value = aws_vpc.vpc_01.id  # correct refs
  value = module.vpc.vpc_id
}

output "private-subnet-1" {
  value = module.vpc.private_sub_1
}
output "private-subnet-2" {
  #   value = aws_subnet.private-app-subnet-2.id
  value = module.vpc.private_sub_2
}
output "pub-subnet-1" {
  #   value = aws_subnet.public-web-subnet-1.id
  value = module.vpc.public_sub_1
}
output "pub-subnet-2" {
  #   value = aws_subnet.public-web-subnet-2.id
  value = module.vpc.public_sub_2
}
output "db-subnet-1" {
  #   value = aws_subnet.private-db-subnet-1.id
  value = module.vpc.db_sub_1
}
output "db-subnet-2" {
  #   value = aws_subnet.private-db-subnet-2.id
  value = module.vpc.db_sub_2
}

output "igw" {
  value = module.vpc.igw
}

output "nat-gateway" {
  value = module.vpc.nat_1_id

}

output "eip_id" {
  value = module.vpc.eip_id
}

############
## CHAT REFS
# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

# output "private-subnet-1" {
#   value = module.vpc["private-sub-1"]
# }

# output "private-subnet-2" {
#   value = module.vpc["private-sub-2"]
# }

# output "pub-subnet-1" {
#   value = module.vpc["public-sub-1"]
# }

# output "pub-subnet-2" {
#   value = module.vpc["public-sub-2"]
# }

# output "db-subnet-1" {
#   value = module.vpc["db-sub-1"]
# }

# output "db-subnet-2" {
#   value = module.vpc["db-sub-2"]
# }
