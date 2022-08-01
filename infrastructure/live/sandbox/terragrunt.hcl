remote_state {
  backend = "s3"
  generate = {
    path      = "backend_generated.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "999999999999-terraform-state"

    key            = "terragrunt-terraform-blueprint/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terragrunt-lock"
  }
}

generate "provider" {
  path      = "provider_generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      AwsEnvironment = title(var.env)
      Creator = "${get_env("USER", "NOT_SET")}"
      ManagedBy = "terraform"
    }
  }
}
EOF
}

terraform {

  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=20m"]
  }

  extra_arguments "common_vars" {
    commands = ["import", "plan", "apply"]

    arguments = [
    ]
  }

  extra_arguments "env" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]

    arguments = [
      "-var", "user=${get_env("USER", "NOT_SET")}",
      "-var", "env=${get_env("TF_VAR_env", "sandbox")}",
    ]
  }
}

generate "config" {
  path = "config_generated.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
variable "standard_tags" {
  type        = map
  description = "Standard tags for all resources that support them"
  default = {
    AwsEnvironment = "sandbox"
  }
}

variable "user" {
  type        = string
  description = "Current user who's executing the plan"
}

variable "application_name" {
  type        = string
  description = "Unique identifier for the application"
  default     = "terragrunt-terraform-blueprint"
}

variable "env" {
  type        = string
  description = "Environment"
  default     = "sandbox"
}

variable "region" {
  type        = string
  description = "Environment"
  default     = "eu-west-1"
}
EOF
}
