###################
## VPC NETWORKING COMPONENTS CONFIGS
###############################
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

# output "eip_id" {
#   value = module.vpc.eip_id
# }

output "web_sgroup" {
  value = module.sgroup.web_layer_sg_id
}


output "app_sgroup" {
  value = module.sgroup.app_layer_sg_id
}

output "db_sg" {
  value = module.sgroup.db_layer_sg_id
}

output "eip_id_" {
  value = module.vpc.eipid
}

output "nat-gateway_id" {
  value = module.vpc.nat_1_id
}

output "rds_arn" {
  value = module.rds.rds_instance_arn
}

output "name" {
  value = module.rds.rds_instance_id
}


########
# SNS OUTPUTS
output "sns_topic_arn" {
  value = module.sns.sns_arn
}

output "sns_topic_id" {
  value = module.sns.sns_id
}

output "sns_name" {
  value = module.sns.sns_name
}

###############
# ASG OUPUTS
output "asg_web_id" {
  value = module.asg.web_asg_id
}
# ASG OUPUTS
output "asg_web_arn" {
  value = module.asg.web_asg_arn
}


output "asg_app_id" {
  value = module.asg.app_asg_id
}
# ASG OUPUTS
output "asg_app_arn" {
  value = module.asg.web_asg_id
}

###############
# ALB OUTPUTS
output "alb_web_id" {
  value = module.alb.external_alb_id
}
output "alb_web_arn" {
  value = module.alb.external_alb_target_arn
}
output "alb_app_arn" {
  value = module.alb.internal_alb_arn
}
output "alb_app_id" {
  value = module.alb.internal_alb_id
}

output "sns_arn" {
  value = module.sns.sns_arn
}
output "sns_id" {
  value = module.sns.sns_id
}


output "app_cwatch_increase_policy" {
  value = module.cwatch.app_increase_ec2_policy_id
}
output "app_cwatch_decrease_policy" {
  value = module.cwatch.app_decrease_ec2_policy_arn
}
output "web_cwatch_increase_policy" {
  value = module.cwatch.web_increase_ec2_policy_arn
}
output "web_cwatch_decrease_policy" {
  value = module.cwatch.web_decrease_ec2_policy_id
}


###################################
## S3 SOURCE AND REPLICA BUCKETS
output "s3_source_bucket_id" {
  value = module.s3.origin_bucket_id
}
output "s3_source_bucket_arn" {
  value = module.s3.origin_bucket_arn
}
output "s3_source_bucket_region" {
  value = module.s3.origin_bucket_region
}
output "s3_repica_bucket_id" {
  value = module.s3.replica_bucket_id
}
output "s3_replica_bucket_arn" {
  value = module.s3.replica_bucket_arn
}
output "s3_replica_bucket_name" {
  value = module.s3.replica_bucket_region
}

##################
## EC2 OUTPUTS
# output "pub_instance_ip_1" {
#   value = module.ec2.public_id_1
# }
# output "pub_instance_ip_2" {
#   value = module.ec2.public_ip_1
# }
# output "pub_instance_ip_1" {
#   value = module.ec2.public_id_1
# }
# output "pub_instance_ip_1" {
#   value = module.ec2.public_id_1
# }