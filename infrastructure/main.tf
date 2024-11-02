data "aws_caller_identity" "current" {}

#Resources to deploy the application
resource "aws_s3_bucket" "static_webapp_bucket" {
  bucket = "static-webapp-${var.environment}-${local.account_id}"

  tags = {
    environment = {var.environment}
  }
}

resource "aws_s3_bucket_ownership_controls" "ownerhsip" {
  bucket = aws_s3_bucket.static_webapp_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Block Public Access Settings
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_webapp_bucket.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [ 
    aws_s3_bucket_ownership_controls.ownerhsip,
    aws_s3_bucket_public_access_block.public_access
   ]
   bucket = aws_s3_bucket.static_webapp_bucket.id
   acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.static_webapp_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.static_webapp_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = [
            "s3:GetObject"
        ],
        Resource  = [
            "${aws_s3_bucket.static_webapp_bucket.arn}",
            "${aws_s3_bucket.static_webapp_bucket.arn}/*"
        ]
      }
    ]
  })
}