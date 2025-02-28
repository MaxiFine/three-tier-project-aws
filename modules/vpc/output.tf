output "vpc_id" {
  value = aws_vpc.vpc_01.id

}

output "public_sub_1" {
  # value = aws_subnet.public_web_subnet-1.id
  value = aws_subnet.public-web-subnet-1.id
}
output "public_sub_2" {
  value = aws_subnet.public-web-subnet-2.id
}
output "private_sub_1" {
  value = aws_subnet.private-app-subnet-1.id
}
output "private_sub_2" {
  value = aws_subnet.private-app-subnet-2.id
}
output "db_sub_1" {
  value = aws_subnet.private-db-subnet-1.id
}
output "db_sub_2" {
  value = aws_subnet.private-db-subnet-2.id
}

output "igw" {
  value = aws_internet_gateway.igw.id
}

output "nat_1_id" {
  value = aws_nat_gateway.nat_1.id
}
output "eipid" {
  value = aws_eip.eip_nat.id
}