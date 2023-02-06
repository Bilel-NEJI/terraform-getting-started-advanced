# This is the explanation file for the folder "terraform46":


## Step 50:
- we are going to work terraform resource lifecycle
- see the .pdf for more details
- what we are going to do:
    - task 1: Use "create_before_destroy" with a simple AWS security group and instance
        - 1st we are going to add a new security group to the "security_group" list of our server module
        - so we go into an existing server_subnet and then we add a new security_group, the security_group which is labeled "main" into our security_group list
        - then we are going to make a change to our aws security_group; we are going to change the name of our security group
    - task 2: Use "prevent_destroy" with an instance
        - even if terraform mark it to be destroyed
        - so we go back to our security group, inside our lifecycle block and add this "prevent_destroy = true"
        - then run "terraform destroy" --> it will not be destroyed --> an error