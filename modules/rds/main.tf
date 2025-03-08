

##################################
## NEW FIX RDS 
resource "aws_db_subnet_group" "rds_subnets" {
  name       = "rds-subnets"
  subnet_ids = [var.db_subnet_1, var.db_subnet_2]

  tags = {
    Name = "RDS Subnets Group Private Subs"
  }
}

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

resource "aws_iam_role_policy_attachment" "rds_monitoring_attachment" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_kms_key" "rds_kms_key" {
  description             = "My KMS Key for RDS Encryption"
  deletion_window_in_days = 30

  tags = {
    Name = "RDSKMSKey"
  }
}

resource "aws_db_parameter_group" "rds_db_pmg" {
  name   = "ps-gd-pg"
  family = "postgres15"

  parameter {
    name         = "max_connections"
    value        = "100"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "statement_timeout"
    value        = "15000"
    apply_method = "immediate"
  }

  parameter {
    name         = "work_mem"
    value        = "4096"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_instance" "terra_rds_intance" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "15.9"
  instance_class          = "db.t3.micro"
  identifier              = "mxterards"
  username               = var.db_u_name
  password               = var.db_pass

  vpc_security_group_ids = [var.db_sec_group_id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:04:30"

  skip_final_snapshot         = true
  final_snapshot_identifier   = "db-snap"

  monitoring_interval         = 60
  monitoring_role_arn         = aws_iam_role.rds_monitoring_role.arn
  performance_insights_enabled = true

  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds_kms_key.arn

#   lifecycle {
#     create_before_destroy = false
#   }  # to avoid instances replacements

  parameter_group_name = aws_db_parameter_group.rds_db_pmg.name
  multi_az            = true     # causing instances replacements all the time
}

resource "aws_db_instance" "terra_rds_replica" {
  replicate_source_db   = aws_db_instance.terra_rds_intance.identifier
  instance_class        = "db.t3.medium"
  identifier            = "mxterards-replica"
#   availability_zone     = "eu-central-1a"  # not for multi-az
  skip_final_snapshot   = true
 

  engine_version        = "15.9"

  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds_kms_key.arn

  backup_retention_period   = 7
  monitoring_interval       = 60
  monitoring_role_arn       = aws_iam_role.rds_monitoring_role.arn
  performance_insights_enabled = true
  parameter_group_name      = aws_db_parameter_group.rds_db_pmg.name
#   multi_az                 = false  # not to be used for replca and instances replacements
}


# not using automated backups for eu-west-1
# resource "aws_db_instance_automated_backups_replication" "replica_default_region" {
#   source_db_instance_arn = aws_db_instance.terra_rds_intance.arn
#   retention_period       = 14
#   kms_key_id             = aws_kms_key.rds_kms_key.arn
  
# }

resource "aws_iam_policy" "kms_rds_access" {
  name        = "kms-rds-access"
  description = "IAM policy to allow RDS to use KMS key"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:Encrypt"
        ],
        Resource = aws_kms_key.rds_kms_key.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_kms_rds_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = aws_iam_policy.kms_rds_access.arn
}
