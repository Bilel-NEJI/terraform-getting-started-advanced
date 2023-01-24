# This is the explanation file for the folder "terraform2":


## Step 4:
- Goal of the step: is to start with the basics of terraform
- we can use "terraform validate" to validate our configuration (like the syntax of the code etc)
- we can generate a terraform plan with the command "terraform plan"
- to save this plan with the command "terraform plan -out myplan", so when we want to apply that specific plan, we can easily refer to; type typing "terraform apply myplan"
- to see the destroy plan, we can type "terraform plan -destroy"
- to delete all the resource, type "terraform destroy"

## Step 5:
- in this step we are going to touch the HCL (HashiCorp Configuration language)
- what we are going to do in to add en EC2 instance to the Public Subnet (the same example that we started with; the VPC that exists in a specific region. Inside that VPC we have 03 Public subnet and 03 private subnet)
- we will add our credentials to the provider block (main.tf), they will be hardcoded (access_key & secret_key) which is not recommended, but it is a way of three different ways. So generally wea re going to use environment variable (which is one of the 03 ways)
- then we are going to add new resource block
- then "terraform init/validate/plan/apply"