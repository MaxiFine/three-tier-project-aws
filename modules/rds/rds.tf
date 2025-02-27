########################
### DATABSE SUBNET GROup
# resource "aws_db_subnet_group" "database-subnet-group" {
#   name        = "database subnets"
#   subnet_ids  = [var.db_subnet_1, var.db_subnet_2]
#   description = "Subnets gropy for db instances"


#   tags = {
#     Name = "Database Subnets"
#   }
# }



# resource "aws_db_instance" "db_instance" {
#   allocated_storage = 20
#   storage_type      = "gp2"
#   engine            = "postgres"
#   engine_version    = "12.19"
#   instance_class    = "db.t3.micro"
#   # name                = var.db_user
#   username               = "postgres"
#   password               = "maxwell22"
#   parameter_group_name   = "default.postgres12"
#   skip_final_snapshot    = true
#   # multi_az               = var.multi-az-deployment
#   availability_zone      = "eu-west-1a"
#   vpc_security_group_ids = [aws_security_group.database-security-group.id]

# }


# ## Allowing RDS TO choose its az
# resource "aws_db_instance" "db_instance" {
#   allocated_storage      = 20

#   storage_type           = "gp2"
#   engine                 = "postgres"
#   engine_version         = "12.19"
#   instance_class         = "db.t3.micro"
#   username               = "postgres"
#   password               = "maxwell22"
#   parameter_group_name   = "default.postgres12"
#   skip_final_snapshot    = true
#   vpc_security_group_ids = [aws_security_group.database-security-group.id]
#   db_subnet_group_name   = var.db_sec_group
#   # availability_zone attribute removed
#   # multi_az = 
# }


################################
### RDS CONFIGS WITH MULTI AZ + READ REPLICAS

resource "aws_db_subnet_group" "rds_subnets" {
  name       = "rds-subnets"
  subnet_ids = [var.db_subnet_1, var.db_subnet_2]

  tags = {
    Name = "RDS Subnets Group Private Subs"
  }
}


#######################
## IAM for rds monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
  Version = "2012-10-17",
  Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }
  ]
})
}


################
## IAM Attatchment to Policy
resource "aws_iam_policy_attachment" "rds_monitoring_attachment" {
  name = "rds-monitoring-attachment"
  roles = [aws_iam_role.rds_monitoring_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


#################
## PARAMETER GROUP
resource "aws_db_parameter_group" "my_db_pmg" {
  name   = "my-db-pg"
  family = "postgres12"  # Changed from mysql5.7 to postgres12

  # Example parameter: adjust max_connections
  parameter {
    # name  = "max_connections"
    # value = "100"
    name = "connection_timeout"
    value = "15"
  }
}



resource "aws_db_instance" "terra_rds_intance" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "12.19"
  instance_class    = "db.t3.micro"
  identifier        = "mydb"
  username          = "mxterradb"
  password          = "maxwell22"

  vpc_security_group_ids = [var.db_sec_group]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name

  # automating backup configs
  backup_retention_period = 7
  backup_window = "03:00-04:00"
  # backup_target = 
  maintenance_window = "mon:04:00-mon:04:30"

  # # Enabling automated back
  skip_final_snapshot = false
  # snapshot_identifier = 
  final_snapshot_identifier = "db-snap"

  # Enabling Monitoring
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn

  # Performance insight
  performance_insights_enabled = true

  # parameter group
  parameter_group_name = aws_db_parameter_group.my_db_pmg.name
}

