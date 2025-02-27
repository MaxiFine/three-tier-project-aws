output "rds_instance_id" {
    value = aws_db_instance.db_instance.id 
}

output "rds_instance_arn" {
  value = aws_db_instance.db_instance.arn
}