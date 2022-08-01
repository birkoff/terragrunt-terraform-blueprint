output "frontend_dist_domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "CloudFront distribution domain name of the frontend"
}

output "frontend_record" {
  value = aws_route53_record.this.fqdn
}