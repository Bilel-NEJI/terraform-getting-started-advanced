# Step 18 | task 1: check the terrafrom version with "terrafom version"
# Step 18 | task 2: install terraform TLS provider
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    http {
      source  = "hashicorp/http"
      version = "2.1.0"
    }
    random {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    # Step 18 | task 2: install terraform TLS provider
    # then we add the TLS provider here
    # then we run "terraform init"
    # then we run "terraform version" to see which are the installed providers just after the "terraform init"
    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}


