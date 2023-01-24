# This is the explanation file for the folder "terraform4":


## Step 7:
- Goal of the step: is to configure the provider block (different configurations)
    - configure terraform aws provider
    - configure aws credentials for terraform provider
- using the "provider" we can provide credentials to our backend platform in few different ways
- method 1: we can hardcode the credentials inside the provider block --> this is not recommended
- method 2: we can use the environment variables by exporting them. to do so, open the terminal and type and run
    - export AWS_ACCESS_KEY="blablablabla"
    - export AWS_SECRET_KEY="blablablablablablablabla"
- method 3: we can use a shared credentials or a configuration file (inside our provider block)
    - by adding this line (shared_credentials_files = "/users/bilen/.aws/creds") to the provider block
    and if you have multiple profiles, you can specify the exact profile by adding the line (profile = "bileln-us-east-1")


## Step 8:
- Goal of the step: is to talk about the terraform resource blocks
- with the resource block we can define our resources inside aws or azure
- inside the resource block we can use the for loop to create multiple resource
- what we are going to do is:
    - task 1: view and understand an existing resource block (we will focus on the "aws_route_table")
    - task 2: add two new resource to deploy an amazon s3 bucket
    - task 3: create a new aws security group (then we can run "terraform plan", "terraform apply -auto-approve")
    - task 4: configure a resource from the random provider
    - task 5: update the amazon s3 bucket to use the random id (we are going to use that 16_lenght_random_id for our S3 bucket). Note: since aws require that the resource name should be globally unique, so that's mean that we can use the random_provider to generate random id to use to automate the S3 bucket, that's a solution, because that's unlikely to match that random_16_lenght_id from any other aws user