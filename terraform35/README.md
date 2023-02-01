# This is the explanation file for the folder "terraform35":


## Step 39:
- how to work with sensitive data in our state configuration
- see the .pdf for more details 
- whar we are going to do:
    - task 1: View state file in raw format
    - task 2: Suppress sensitive information
        - we are going to protect some sensitive values
        - for the demo we will create a new file called "contactinfo.tf" and put inside it some variables, resources, and outputs
        - and we will mark some of them as sensitive by adding the "sensitive" argument to the variables only (in this stage)
        - then if we run "apply" we will notice errors --> because they are sensitive data and can not be outputed this easy
        - so we go back to our new file and also update the variables by adding the argument "sensitive = true"
        - then "apply" --> by doing this we will no te able to see the values of the sensitive outputs in the terminal but we still can see the non sensitive values (like "my_number" in this example)
    - task 3: View the Terraform state file
        - here we want to control who can access to the state file = terraform backend
        - for example if we are using s3-bucket --> we can use IAM policy to control access
        - also can be done with terraform cloud (when storing the terraform backend inside terraform cloud)