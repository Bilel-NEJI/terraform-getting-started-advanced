terraform {
  # backend "local" {
  #   path = "terraform.tfstate"
  # }
  
  # Step 36 | task 2: Authentication: S3 Standard Backend
  # backend "s3" {
  #   path   = "my-terraform-state-bn"
  #   key    = "prod/aws_infra"
  #   region = "us-east-1"

  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }

  # Step 34 | task 2: Standard Backend: HTTP Backend (Optional)
  # this the block that will replace (if needed) other backends --> it's going to be backend http
  # backend "http" {
  #   address        = "http://localhost:5000/terraform_state/my_state"
  #   lock_address   = "http://localhost:5000/terraform_lock/my_state"
  # 
  #   lock_method    = "PUT"
  #   unlock_address = "http://localhost:5000/terraform_lock/my_state"
  #   unlock_method  = "DELETE"
  # }


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
