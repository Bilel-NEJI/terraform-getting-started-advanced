# This is the explanation file for the folder "terraform21":


## Step 25:
- how to work with terraform state command
- it allows us to interract with the terraform state file
- if we did in the past a "terrafom apply", we will have "terraform.tfstate" file (json format)
- and with each achieved "apply" operation, we will have a backup file called "terrafom.tfstate.164xxxxxx65.backup"
- what the terraform state command do for us? it interract with the json format state file, so we won't need to go there and deal with it
- see the attached pdf file for more details
- what we are going to do:
    - task 1: Deploy Infrastructure Using Terraform (this task already done too many times = "terraform apply")
    - task 2: Utilize the "terraform show" command to show state information
        - this command will render our entire .tf state file in a easier read format
    - task 3: Utilize the "terraform state" command to show state information
        - we can check the command "terraform state -help"
    - task 4: Utilize the "terraform state" command to list resource information ("terraform state list")
    - task 5: Utilize the "terraform state" command to show resource information ("terrafom state show aws_instance.web_server")