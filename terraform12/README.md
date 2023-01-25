# This is the explanation file for the folder "terraform12":


## Step 16:
- we can refer to the attached pdf, it has all the details
- since we can specify the terraform version, we can also specify the providers version
- we create a folder called "providers", and inside of it we create a file called "terraform.tf" where we add a terraform block with required version
- then we go to the "providers" folder (with therminal) and run the command "terraform init"; that will initialize the providers plugins
- we can also validate our require specific version of providers that we want to use --> so we go to the "terraform.tf" file (providers folder) and add the "required_providers" block --> then we run "terraform init"
- in production we will require a specific version of terraform and the providers since we don't want to let our selves to surprises