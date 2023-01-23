# This is the explanation file:


## Step 1:
- Goal of the step: is to show the diffrence between using the AWS Management consoel and the Terraform code. With terraform you can create and destroy many resources with code, not the same as the AWS managament console you will need to repeat the creation of the public_subnet or private subnets, etc
- So what are we going to setuo with Terraform (meaning the exalpe that we are working on): It's a simple exampple (the same done with the AWS Management Console); we are going to create an aws "vpc" in which we find:
    - 03 public subnets (in three diffrent avaibility zone)
    - 03 private subnets (in the same three diffrent avaibility zone)
    - route table for the subnets
    - route table associations
    - 01 intenet gateway
    - 01 EIP for NAT Gateway
    - 01 NAT Gateway
- after having the files "main.tf" and "varaibles.tf" and typing code there
- we go to aws and create a user with access_key_id | secret_access_key and give him the permission of administrator (in real app in should be lower thatn administrator)
- then set our credentials (meaning the user's credentials), we open a terminal in the folder "terraform1" and type and (one by one):
```
export AWS_ACCESS_KEY_ID="balblablablabla"
```
```
export AWS_SECRET_ACCESS_KEY_ID="balblablablabla"
```
- you can use the command "terraform fmt" to format you code (the terminal ist open in the folder "terminal1" for example)
- then we should type "terraform init" to initialize our project so it can go and download a plugin from the aws provider that we set inside the "main.tf" file (remember every time we go to a different directory we need to initiliaze that directory)
- then we can type "terraform plan" to see/check the new state that we want to create
- finally we can type "terraform apply"
- to destroy all the resources we can use "terraform destroy".

## Step 2:
- to see all the resources that we have in our state file; we can run the command "terraform show"
- the sate file which is stored locally in our machine
- when working with others colleages we need to save that same state file in remote place, like amazon S3 bucket or terraform cloud, in order to access both the same file

## Step 3:
- we will add a data block and a resource block (EC2 instance as a web server which will be saved in one of our public subnet that we already created)
- and then by typing "terraform plan", terraform will compare our updated configuration file to the state file --> result 01 resource will be added which the EC2 instance
- then if we finished checking that plan we can type "terraform apply"
- if we want to show the new state after the "apply" of course we can type "terraform show"
- also we can list the resources without details bu running "terraform state list"