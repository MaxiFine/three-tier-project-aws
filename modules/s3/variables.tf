output "s3_source_bucket_id" {
  value = aws_s3_bucket.origin.id
}
output "s3_source_bucket_arn" {
  value = aws_s3_bucket.origin.arn
}
output "s3_dest_bucket_id" {
  value = aws_s3_bucket.replica.id
}
output "s3_replica_bucket_arn" {
  value = aws_s3_bucket.replica.arn
}