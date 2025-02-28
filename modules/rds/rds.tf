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
  name       = "rds-monitoring-attachment"
  roles      = [aws_iam_role.rds_monitoring_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


#################
## PARAMETER GROUP   ///////////soome error here
# resource "aws_db_parameter_group" "my_db_pmg" {
#   name   = "my-db-pg"
#   family = "postgres12" # Changed from mysql5.7 to postgres12

#   # Example parameter: adjust max_connections
#   parameter {
#     name  = "max_connections"
#     value = "100"
#   }
# }

resource "aws_db_parameter_group" "my_db_pmg" {
  name   = "my-db-pg"
  family = "postgres12"  # PostgreSQL 12

  parameter {
    name  = "max_connections"
    value = "100"
  }

  parameter {
    name  = "statement_timeout"  # Instead of connection_timeout
    value = "15000"  # Value in milliseconds (15 seconds)
  }

  parameter {
    name  = "work_mem"
    value = "4096"
  }
}


###################
## ENCRYPTION[DATA ACCESS AND SECURITY]
resource "aws_kms_key" "rds_kms_key" {
  description             = "My KMS Key for RDS Encryption"
  deletion_window_in_days = 30

  tags = {
    Name = "RDSKMSKey"
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
  backup_window           = "03:00-04:00"
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

  # Encryption for access and security
  kms_key_id = aws_kms_key.rds_kms_key.arn

  # parameter group
  parameter_group_name = aws_db_parameter_group.my_db_pmg.name

  # Multi az deployments
  multi_az = true

}



##################
## READ REPLICA CONFIGS
resource "aws_db_instance" "terra_rds_replica" {
  replicate_source_db = aws_db_instance.terra_rds_intance.identifier
  instance_class      = "db.t3.medium"

  vpc_security_group_ids = [var.db_sec_group]
  
  backup_retention_period      = 7
  backup_window                = "03:00-04:00"
  maintenance_window           = "mon:04:00-mon:04:30"
  skip_final_snapshot          = false
  final_snapshot_identifier    = "my-db"
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn
  performance_insights_enabled = true
  storage_encrypted            = true
  kms_key_id                   = aws_kms_key.rds_kms_key.arn

  parameter_group_name = aws_db_parameter_group.my_db_pmg.name

  # Enable Multi-AZ deployment for high availability
  multi_az = true
}



#####################
## AUTOMATED BACKUPS FOR RDS IN CROSS REGION
provider "aws" {
  region = "eu-central-1"
  alias  = "terra_rds_replica"
}

resource "aws_db_instance_automated_backups_replication" "replica_default_region" {
  source_db_instance_arn = aws_db_instance.terra_rds_intance.arn
  retention_period       = 14
  kms_key_id             = aws_kms_key.rds_kms_key.arn

  provider = aws.terra_rds_replica
}

# resource "aws_kms_key" "my_kms_key_us_west" {
#   description = "My KMS Key for RDS Encryption"
#   deletion_window_in_days = 30

#   tags = {
#     Name = "MyKMSKey"
#   }

#   provider = aws.replica
# }