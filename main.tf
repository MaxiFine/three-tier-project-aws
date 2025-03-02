terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.88.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  db_subnet_1_cidr      = var.db_subnet_1_cidr
  db_subnet_2_cidr      = var.db_subnet_2_cidr

}

#### ALB  ########
module "alb" {
  source               = "./modules/alb"
  vpc_id               = module.vpc.vpc_id
  public_web_subnet_1  = module.vpc.public_sub_1
  public_web_subnet_2  = module.vpc.public_sub_2
  private_app_subnet_1 = module.vpc.private_sub_1
  private_app_subnet_2 = module.vpc.private_sub_2
  web_sgroup           = module.sgroup.web_layer_sg_id
  app_sgroup           = module.sgroup.app_layer_sg_id


}


module "sgroup" {
  source   = "./modules/sgroup"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
}


module "ec2" {
  source               = "./modules/ec2"
  vpc_id               = module.vpc.vpc_id
  web_security_group   = module.sgroup.web_layer_sg_id
  app_security_group   = module.sgroup.app_layer_sg_id
  public_web_subnet_1  = module.vpc.public_sub_1 # Using bracket notation for outputs with hyphens
  public_web_subnet_2  = module.vpc.public_sub_2 # Us
  private_app_subnet_1 = module.vpc.private_sub_1
  private_app_subnet_2 = module.vpc.private_sub_2



}


module "asg" {
  source                = "./modules/asg"
  vpc_id                = module.vpc.vpc_id
  private_subnet_1_cidr = module.vpc.private_sub_1
  private_subnet_2_cidr = module.vpc.private_sub_2
  public_subnet_1_cidr  = module.vpc.public_sub_1 # Us
  public_subnet_2_cidr  = module.vpc.public_sub_2 # Us
  asg_app_sg            = module.sgroup.app_layer_sg_id
  asg_web_sg            = module.sgroup.web_layer_sg_id
  web_alb_arn           = module.alb.external_alb_target_arn
  # app_alb_arn           = module.alb.internal_alb_arn
  app_alb_arn           = module.alb.internal_alb_target_arn
  key_name = module.key_pair.rsa_key_name
}


module "s3" {
  source = "./modules/s3"

}

module "rds" {
  source       = "./modules/rds"
  db_sec_group = module.sgroup.db_layer_sg_arn
  db_subnet_1  = module.vpc.db_sub_1
  db_subnet_2  = module.vpc.db_sub_2

}

module "sns" {
  source = "./modules/sns"

}

module "cwatch" {
  source          = "./modules/cwatch"
  sns_topic_arn   = module.sns.sns_arn
  web_inc_asg_arn = module.asg.web_increase_policy_arn
  web_decr_asg    = module.asg.web_decrease_policy_arn
  app_Inc_asg_arn = module.asg.app_increase_policy_arn
  app_dcr_asg_arn = module.asg.app_reduce_policy_arn
}

module "key_pair" {
  source          = "./modules/kpair"
}

# module "route53" {
#   source = "./modules/route53"
# }



