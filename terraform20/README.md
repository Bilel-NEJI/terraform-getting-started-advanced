# This is the explanation file for the folder "terraform20":


## Step 24:
- how to work with terraform workspace; using the same code base and have different environment (development, production, stage, etc)
- knowing that terraform depends on the "state", so it needs to store the state in the "terraform.tf" file
- terraform needs to map real world resource to our configuration, so it need a place to store the state and here comes terraform workspaces, so terraform state belongs to terrafom workspaces --> in fact we were deploying all those resources in a default workspace, but we can change which workspace we want to store state in
- so let's go and take a look on the terraform workspace command and how it relates to these DRY (Don't Repeat Yourself) and being able to toggle between those different environments
- we can use the command "terraform workspace show" to see which workspace we are working with currently (to see all commands related to the workspace use "terraform workspace -help")
- see the attached pdf file for more details
- what we are going to do:
    - task 1: Using Terraform Workspaces (Open Source)
    - task 2: Create a new Terraform Workspace for Development State
        - we want to use the same terraform configuration, but we want to deploy to different region within aws
        - for this we go to the terminal and run "terraform workspace new develoment" = "terraform workspace new the_of_the_new_workspace" --> the workspace will be created (it will be new and empty - and there is nos state file created there --> "terraform show") and we are going to be directly swithed to that workspace
    - task 3: Deploy Infrastructure within the Terraform development workspace
        - we are goign to make the change to our configuration to point to the "us-west-2" region for our configuration --> so we go to our "main.tf" and change one line (of the provider "aws" --> region = us-west-2)
        - then we go and run the command "terraform plan" --> we will see that there is too many resources/adds to add since the new workspace (development is empty/no state for far) --> so we run "terraform apply"
    - task 4: Changing between Workspaces
        - to change between, we type "terraform workspace select default"
        - we can verify with the command "terraform show" and check which region that we are using
    - task 5: Utilizing the ${terraform.workspace} interpolation sequence within your configuration
        - we accually can use interpolation sequence to identify which workspace I'm in
        - for that we type "terraform workspace select development" (once again we are now in relation with us-west-2)
        - and then we go to our code base "main.tf" --> "aws" provider and add a new tag
        - so this will be for any new items that get created inside my aws environment
        - this will populate the workspace name into our terraform configuration using interpolation sequence
        - if we run "terrafom plan" this will indicate the tag (which is development, the current one that we already selected) in each resource --> so we go ahead and apply that

