# This is the explanation file for the folder "terraform15":


## Step 19:
- how to work with Fetch, Version, Upgrade Terraform Providers
- it a bad practice to do "not" version your providers --> we must version our providers
- see the attached pdf file for more details
- what we are going to do:
    - task 1: Check Terraform and Provider version --> "terraform version"
    - task 2: Require specific versions of Terraform providers --> we already did that in previous labs
        - if we want to update the version that we are using, we run the command "terraform init -upgrade"
    - task 3: Upgrade provider versions
        - when we run the "terraform init", once installed, terraform will generate what is called a "dependencies lock" represented with the file ".terraform.lock.hcl"
        - the content of that file are:
            - it highlights exactly where the provider was installed from (for each provider)
            - also the hashes code values of each provider
        - let's simulate a change to one of our providers --> it will be the random provider ("terrafrom.tf" file)
        - 
