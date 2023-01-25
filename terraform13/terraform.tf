# Step 16 | task 1 & 2: Install Terraform HTTP provider version
# so we come here and add the http provider
# then to install this provider we run "terraform init"
# then we can validate with "terraform validate"
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    # Step 16 | task 3: Install Terraform (an other provider) Random provider version
    # this the add line foe the http provider
    http {
      source  = "hashicorp/http"
      version = "2.1.0"
    }

    # Step 16 | task 3 & 4: Install Terraform (an other provider) Random provider version
    # remember we can check the installed providers with the command "terraform version"
    # then of course we run the "terraform init" ("terrafrom version")
    random {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    # Step 16 | task 5: Install Terraform Local provider version
    # this to create local files on a given system whereterraform is running
    # then of course we run the "terraform init" ("terrafrom version")
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
  }
}


