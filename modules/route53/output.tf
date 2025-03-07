output "zone_id" {
  value = aws_route53_zone.main.id
}


output "zone_arn" {
  value = aws_route53_zone.main.arn
}


output "zone_name" {
  value = aws_route53_zone.main.name
}


output "primaryhealthcheck_id"  {
    value = aws_route53_health_check.primary_health_check_http.id
  
}

# output "zone_name" {
#  value = aws_route53_zone.main.name 
# }