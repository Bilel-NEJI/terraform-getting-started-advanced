# This is the explanation file for the folder "terraform39":


## Step 43:
- we are going to continue talking about variables and variables validation and suppression
- see the .pdf for more details 
- whar we are going to do:
    - task 1: Validate variables in a configuration block
        - how we can validate the variables when we add the values in there (by default, .tfvars file, cli)
        - here we want to ensure that our modules or terraform configurations are using the proper values for the varaibles as they are intended to be used
        - so fo this lab we create a folder called "variable_validation"
        - inside of it we create a file called "variables.tf" file and put content there, this is the file that we are going to work with --> creating the variable "cloud" with two validation statements
        - the 1st statement is for: the condition must contain either aws, azure, gcp, vmware. so we are making sure that matchs one of these four strings (aws, azure, gcp, vmware) [== var.cloud]  --> we also did add an error message; in case that the condition does not match, terraform will show that error message
        - the 2nd statement is for: we are taking our variable and use the "lower" function to ensure that the "cloud" name must not have any capital letter --> we also did add an error message; in case that the condition does not match, terraform will show that error message
        - then in the terminal we go the "variable_validation" folder and run "init"
        - then run "plan" --> what will happen since we did not set a value of the new "cloud" variable, terraform will ask us to enter a new value inside the terminal --> so if we enter the word "aws" (which matches all our validation statements/conditions) he will accept it since we did not make any changes in our configuration file
    - task 2: More Validation Options
        - we go to our new "variables.tf" file and add a new variables with some validation statement
        - then run the commands to test those validation statements:
            - terraform plan -var cloud=aws -var no_caps=training -var ip_address=1.1.1.1 -var character_limit=rpt --> here everything is good and match our validation statements
            - terraform plan -var cloud=all -var no_caps=Training -var ip_address=1223.22.342.22 -var character_limit=ga --> here error message show up and do not match our validation statements
    - task 3: Suppress sensitive information (hide sensitive values from the terminal)
        - we did talk about this before
        - so inside the "variables.tf" we go and add new variables with "sensitive = true", also we added few outputs there to show them when working with it
        - then run the command: terraform apply -var cloud=aws -var no_caps=training -var ip_address=1.1.1.1 -var character_limit=rpt
        - by runnig this correct command, we will see an error because of the variable "phone_number" has that sensitive argument --> so it can not be displayed --> because terraform is smart enough to detect that the input variable "phone_number" is sensitive value and by consequence when we ask to output that value (from the input, the output refers to the that sensitive input); so he will not display it
        - so we should go and add the argument "sensitive = true" to the output "phone_number"
        - then if we go back and run the command: terraform apply -var cloud=aws -var no_caps=training -var ip_address=1.1.1.1 -var character_limit=rpt --> it will run successfully and the sensitive value will be hiden
    - task 4: View the Terraform State File
        - in this section, check the .pdf file to see how to deal with this sensitive argument and how to prepare the needed things to use terraform cloud