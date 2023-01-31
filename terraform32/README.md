# This is the explanation file for the folder "terraform32":


## Step 36:
- how to work with 
- see the .pdf for more details 
- whar we are going to do:
    - task 1: Use Terraform’s default local backend
        - here we assume that we are using the standard local backend
        - so we go the "terraform.tf" file and remove all the backend blocks to enable terraform to use the standard local backend
        - then we run the command "terraform init -migrate-state" to recongiure the nackend, and attempt to migrate any existing state --> with this command terraform will migrate from the previous used backend in previous labs and use the standard local backend --> then "apply"
    - task 2: Migrate State to s3 backend
        - we will migrate from the standard local backend to the s3-bucket backend which is configured in previous labs
        - but the difference here that we are not going to destroy the resources that we have and re-deploy them in the new backend --> no, we are going to migrate all those resources in our local state file to the new s3-bucket backend
        - then we run the command "terraform init -migrate-state" --> terraform will ask us if we want to copy the existing state to the s3-bucket
    - task 3: Migrate State to remote backend
        - we are goign to migrate from a aws s3-bucket to a remote backend
        - see the .pdf file
    - task 4: Migrate back to local backend