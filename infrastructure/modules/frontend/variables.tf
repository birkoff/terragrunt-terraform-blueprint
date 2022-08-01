variable "hosted_zone_id" {
  description = "Hosted Zone ID of the domain in Route53"
}

variable "hosted_domain_name" {
  description = "Domain name in Route53"
}

variable "frontend_subdomain_name" {
  description = "Sub-domain of the HUB frontend target"
}

variable "certificate_arn_global" {
  description = "Certificate ARN for global services"
}

variable "bucket_region" {
  description = "Region of the S3 bucket"
}

variable "bucket_force_destroy" {
  default = "false"
}

variable "cloudfront_function_name" {
//  default = "basic-auth-zenoo-fe"
}

variable "cloudfront_function_runtime" {
  default = "cloudfront-js-1.0"
}

variable "cloudfront_function_publish" {
  default = true
}