include {
  path = find_in_parent_folders()
}
terraform {
  source = "../../../../modules//frontend/"
  extra_arguments "init_args" {
    commands = [
      "init"
    ]
    arguments = [
    ]
  }
}

inputs = {
  certificate_arn_global  = "arn:aws:acm:us-east-1:999999999999:certificate/00000000-1111-2222-3333-444444444444"
  frontend_subdomain_name = "www"
  hosted_domain_name      = "sandbox.test.com"
  hosted_zone_id          = "999999999999"
  bucket_region           = "eu-west-1"
  cloudfront_function_name = "basic-auth-web"
}