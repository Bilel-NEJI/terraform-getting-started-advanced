# This is the explanation file for the folder "terraform37":


## Step 41:
- we are going to deep dive into using terraform input variables
- we are going to talk about different ways that we can set values for our different varaibles
- 
- see the .pdf for more details 
- whar we are going to do:
    - task 1: Set the value of a variable using environment variables
        - in this case we are going to show that we are the variable's value (variable_sub_cidr) is taken by terraform as we declared it inside the "variables.tf" file
        - then we will override it using the environment variables
        - so to check the original/decalred value (which is 10.0.203.0/24) we run:
            - "terraform state list"
            - "terraform state show aws_subnet.variables-subnet"
        - then to override that value we run:
            - export TF_VAR_variables_sub_cidr=10.0.203.0/24
        - then we do "terraform plan" --> we will see the difference --> then "apply"
        - then it will be replaced
    - task 2: Declare the desired values using a .tfvars file (this is the best practice method)
        - this is another way to set values to our variables
        - this is a way to retrieve specific values to variables without requiring us (the operator) to modify or set environment variables, so it will be just using .tfvars file
        - this is the best practice method (to override the value that we want oto change)
        - so we go and create a new file called "terraform.tfvars"
        - then inside it, we set values to our variables, but we don't need to declare all the values of the all the variables that we already have, because those are done inside the "variables.tf" file --> we only set our desired values (of the variables that we want to modify) inside this file
        - we need to remember that in our demo we did override the original values the environment variables
        - so when we run "plan" --> we will see that terraform is still using the overrided value with environment variables "10.0.203.0/24" --> and now terraform is planning to replace it with the new one form "terraform.tfvars" "10.0.204.0/24" (and of course the rest of the changes --> "us-east-1d", etc)
        - then "apply" --> done (we can chekc with "terraform state list" then "terraform state shwo aws_subnet.variables-subnet")
    - task 3: Override the variable on the CLI
        - now using the cli to override
        - this way override all the other ways
        - to do so we can run the following "plan" command: terraform plan -var variables_sub_az="us-east-1e" -var variables_sub_cidr="10.0.205.0/24"
        - then "apply" --> the replacements will be showed --> the command is: terraform apply -var variables_sub_az="us-east-1e" -var variables_sub_cidr="10.0.205.0/24"
        - after doing this, if we run "terraform plan", terraform will go back and read our configuration file and he will find that the address to work with is "10.0.204.0/24" --> so he will show to us that we will moved from "10.0.205.0/24" (the one from the cli) to "10.0.204.0/24" (the one inside our .tsvars file)