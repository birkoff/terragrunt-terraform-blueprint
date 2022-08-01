resource "aws_route53_record" "this" {
  zone_id = var.hosted_zone_id
  name    = "${var.frontend_subdomain_name}.${var.hosted_domain_name}"
  records = [aws_cloudfront_distribution.this.domain_name]
  ttl     = "30"
  type    = "CNAME"
}