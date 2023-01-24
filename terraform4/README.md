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