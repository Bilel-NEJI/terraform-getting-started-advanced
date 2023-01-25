# Step 19 | task 3: Upgrade provider versions --> makeing a change to the "random" provider
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
    # the change will be here
    # then we run "terraform version" --> we'll see that still showing the version "3.1.0"
    # so we need to run "terraform init -upgrade" to go and install/work with the specified version in the change (task 3) --> the same will be reflected in the file ".terraform.lock.hcl"
    # so after having the right version to work with, we can share the ".terraform.lock.hcl" with colleagues and teams to have the same versions that Ii specified
    random {
      source  = "hashicorp/random"
    # before change
    #   version = "3.1.0"
    # after change
      version = "3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}


