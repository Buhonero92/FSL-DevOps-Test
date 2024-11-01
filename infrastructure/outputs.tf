output "bucket_name" {
  value = aws_s3_bucket.static_webapp_bucket.bucket
}

output "website_endpoint" {
  value = "http://${aws_s3_bucket.static_webapp_bucket.bucket}.s3-website-us-east-1.amazonaws.com "
}