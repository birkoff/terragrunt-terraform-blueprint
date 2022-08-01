resource "aws_s3_bucket" "this" {
  arn            = "arn:aws:s3:::${data.aws_caller_identity._.account_id}-${var.frontend_subdomain_name}-${var.hosted_domain_name}"
  bucket         = "${data.aws_caller_identity._.account_id}-${var.frontend_subdomain_name}-${var.hosted_domain_name}"
  force_destroy  = var.bucket_force_destroy
  hosted_zone_id = var.hosted_zone_id
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id

  acl = "public-read"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          "${aws_s3_bucket.this.arn}",
          "${aws_s3_bucket.this.arn}/*",
        ]
      },
    ]
  })
}