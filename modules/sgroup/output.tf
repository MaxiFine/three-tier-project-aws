output "external_alb_layer_sg_id" {
  value = aws_security_group.web_security_group.id
}


output "external_alb_layer_sg_arn" {
  value = aws_security_group.web_security_group.arn
}


output "web_layer_sg_id" {
  value = aws_security_group.web_security_group.id
}


output "web_layer_sg_arn" {
  value = aws_security_group.web_security_group.arn
}


output "app_layer_sg_arn" {
  value = aws_security_group.app_security_group.arn
}


output "app_layer_sg_id" {
  value = aws_security_group.app_security_group.id
}


output "db_layer_sg_arn" {
  value = aws_security_group.database_security_group.arn
}


output "db_layer_sg_id" {
  value = aws_security_group.database_security_group.id
}

