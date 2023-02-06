# This is the explanation file for the folder "terraform44":


## Step 48:
- we are going to work dynamic blocks which allows us to dynamically construct repeatable nested blocks rather than repeating copy and paste
- so with this demo we are going to showcase a terraform resource block configuration that both uses and does not use dynamic block, so we be aware when to use them and when no need to use them
- see the .pdf for more details
- what we are going to do:
    - task 1: Create a Security Group Resource with Terraform
        - we are going to buil a aws-resource-security-group that allows web traffic on ports 443 and 80; inside the "main.tf" file --> this resource is not using dynamic block
    - task 2: Look at the state without a dynamic block
        - we are going to show case what this looks like in state
        - so we run "terraform state list" (--> there we find the new security group that we just created)
        - then we run "terraform state show aws_security_group.main" on the new security group --> to see how it looks like without dynamic block
    - task 3: Convert Security Group to use dynamic block
        - so now we are going to convert our configuration to use the dynamic block
        - so 1st we will start by creating a set of local values that are going to provide a list of my ports that we want to make available to our security group
        - then we use that created dynamic block inside our security-group
    - task 4: Look at the state with a dynamic block
        - here we want to see the difference between not using a dynamic block and using a dynamic block
        - so we run "terraform state list"
        - then we run "terraform state show aws_security_group.main"
        - same us before
    - task 5: Use a dynamic block with Terraform map
        - this time we will also refactor our code but instead of using locals we are going to create and define what the ruleset should be for our security group
        - so we comment/remobe that local block called "ingress_rules"
        - then we go to the file "varaibles.tf" and we add a new variable called "web_ingress"
        - then after defining our variable, we go back to our "main.tf" and refarctor our code to use it
        - then "validate"
        - then "apply" --> no changes also; same results
    - task 6: Look at the state with a dynamic block using Terraform map
        - so we run "terraform state list"
        - then we run "terraform state show aws_security_group.main"