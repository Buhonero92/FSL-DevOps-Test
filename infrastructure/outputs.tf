output "bucket_name" {
  value = aws_s3_bucket.static_webapp_bucket.bucket
}

output "website_endpoint" {
  value = aws_s3_bucket.static_webapp_bucket.website_endpoint
}