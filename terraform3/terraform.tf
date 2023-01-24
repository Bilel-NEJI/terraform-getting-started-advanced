# Step 6:
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
        source = "hashcorp/aws"
        version = "~> 3.0"
    }
  }
}