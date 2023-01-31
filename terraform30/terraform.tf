# Step 34:
# Step 34 | task 1: Authentication: S3 Standard Backend
terraform {
  # backend "local" {
  #   path = "terraform.tfstate"
  # }
  # Step 34 | task 1: Authentication: S3 Standard Backend
  # in this example we want to allow terraform to save our state (file) into an aws resource wichi is s3-bucket
  backend "s3" {
    path   = "my-terraform-state-bn"
    key    = "prod/aws_infra"
    region = "us-east-1"

    # here also we will work a little bit and show the mechanism of enabling locking on an aws s3-bucket (which is not natively supported; so we created a DynamoDB table on our aws account)
    # then we need to implement some code here: "dynamodb_table" and "encrypt"
    # by doing this we will utilize DynamoDB to provide locks (on our s3-bucket backend = state)
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  # Step 34 | task 2: Standard Backend: HTTP Backend (Optional)
  # this the block that will replace the backend "s3" --> backend http
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
