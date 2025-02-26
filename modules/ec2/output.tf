output "public_id_1" {
    description = "AWS instance id"
    value = aws_instance.PublicWebTemplat-1.id
  
}

output "public_id_2" {
    description = "AWS instance id"
    value = aws_instance.PublicWebTemplate-2.id
  
}

output "private_id_1" {
    description = "AWS instance id"
    value = aws_instance.PrivateAppTemplat-1.id
  
}

output "private_id_2" {
    description = "AWS instance id"
    value = aws_instance.PrivateAppTemplate-2.id
  
}
output "public_ip_1" {
    description = "AWS instance id"
    value = aws_instance.PublicWebTemplat-1.public_ip
  
}

output "private_ip_1" {
    description = "AWS instance id"
    value = aws_instance.PublicWebTemplate-2.public_ip
}
output "private_ip_2" {
    description = "AWS instance id"
    value = aws_instance.PrivateAppTemplat-1.public_dns
  
}

output "public_ip_2" {
    description = "AWS instance id"
    value = aws_instance.PrivateAppTemplate-2.public_ip
}




