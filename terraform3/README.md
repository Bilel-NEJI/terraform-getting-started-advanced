# This is the explanation file for the folder "terraform3":

## Step 6:
- we want to see how we can use/set plugins/providers and some commands
- here in the file "terrafomr.tf" we can find/define:
    - the terraform core version --> required_version
    - we can define which providers we need to use --> required_providers
    - an aws setup as a re quired provider --> aws/resource | version
- then when we run "terraform init" we will download the providers that we set as required in our configuration
- to check what are the installed providers we can run "terraform version"
- to see which are the required providers (by state) we can run "terraform providers"