resource "aws_cloudfront_distribution" "this" {
  aliases = ["${var.frontend_subdomain_name}.${var.hosted_domain_name}"]
  comment = "Created by infra code"

  default_cache_behavior {
    allowed_methods = ["GET", "POST", "HEAD", "DELETE", "PUT", "PATCH", "OPTIONS"]
    cached_methods  = ["HEAD", "GET"]
    compress        = "false"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = "false"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "S3-${var.frontend_subdomain_name}.${var.hosted_domain_name}"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "true"

  origin {
    connection_attempts = "3"
    connection_timeout  = "10"

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = "30"
      origin_ssl_protocols     = ["TLSv1.2", "TLSv1", "TLSv1.1"]
    }

    domain_name = "${data.aws_caller_identity._.account_id}-${var.frontend_subdomain_name}-${var.hosted_domain_name}.s3-website.${var.bucket_region}.amazonaws.com"
    origin_id   = "S3-${var.frontend_subdomain_name}.${var.hosted_domain_name}"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = var.certificate_arn_global
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only"
  }
}