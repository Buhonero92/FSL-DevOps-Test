data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "static_webapp_bucket" {
  bucket = "static-webapp-${var.environment}-${local.account_id}"
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

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.static_webapp_bucket.id
  key = "index.html"
  source = "../public/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "manifest" {
  bucket = aws_s3_bucket.static_webapp_bucket.id
  key = "manifest.json"
  source = "../public/manifest.json"
  content_type = "text/json"
}

resource "aws_s3_object" "robots" {
  bucket = aws_s3_bucket.static_webapp_bucket.id
  key = "robots.txt"
  source = "../public/robots.txt"
  content_type = "text/txt"
}

resource "aws_s3_object" "src_folder" {
    bucket = aws_s3_bucket.static_webapp_bucket.id
    for_each = fileset("src", "**/*")
    key = each.key
    source = "src/${each.key}"
}

resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.static_webapp_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
        key_prefix_equals = "src/"
    }
    redirect {
        replace_key_prefix_with = "src/"
    }
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