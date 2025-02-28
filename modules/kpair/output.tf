output "rsa_key_name" {
  value = aws_key_pair.instance_key.key_name
}
output "rsa_key_arn" {
  value = aws_key_pair.instance_key.arn
}
output "rsa_key_id" {
  value = aws_key_pair.instance_key.id
}


