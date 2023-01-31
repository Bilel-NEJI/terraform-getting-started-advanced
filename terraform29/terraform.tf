# Step 33: to mention where to store the terraform state file (default location) this is optional
# Step 33 | task 1: Authentication: S3 Standard Backend
terraform {
  # backend "local" {
  #   path = "terraform.tfstate"
  # }
# Step 33 | task 1: Authentication: S3 Standard Backend
# in this example we want to allow terraform to save our state (file) into an aws resource wichi is s3-bucket
    backend "s3" {
      path = "my-terraform-state-bn"
      key = "prod/aws_infra"
      region = "us-east-1"
  }

  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}