#---------------------------
# Outputs
#---------------------------
output "origin_bucket_arn" {
  value = aws_s3_bucket.origin.arn
}

output "origin_bucket_id" {
  value = aws_s3_bucket.origin.id
}

output "origin_bucket_region" {
  value = aws_s3_bucket.origin.region
}

output "replica_bucket_id" {
  value = aws_s3_bucket.replica.id
}

output "replica_bucket_arn" {
  value = aws_s3_bucket.replica.arn
}

output "replica_bucket_region" {
  value = aws_s3_bucket.replica.region
}

