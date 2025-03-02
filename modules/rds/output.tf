output "rds_instance_arn" {
  # value = aws_db_instance.db_instance.id
  value = aws_db_instance.terra_rds_intance.arn
}

output "rds_instance_id" {
  value = aws_db_instance.terra_rds_intance.id
}

output "rds_instance_ip" {
  value = aws_db_instance.terra_rds_intance.address
}

output "parameter_group_name_id" {
  value = aws_db_parameter_group.rds_db_pmg.id

}

output "parameter" {
  value = aws_db_parameter_group.rds_db_pmg.arn
}