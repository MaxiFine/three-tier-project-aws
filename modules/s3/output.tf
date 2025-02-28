output "s3_source_bucket_id" {
  value = aws_s3_bucket.source_bucket.id
}


output "s3_source_bucket_arn" {
  value = aws_s3_bucket.source_bucket.arn
}


output "s3_dest_bucket_id" {
  value = aws_s3_bucket.destination_bucket.id
}
output "s3_dest_bucket_arn" {
  value = aws_s3_bucket.destination_bucket.arn
}