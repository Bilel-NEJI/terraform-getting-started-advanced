# This is the explanation file for the folder "terraform29":


## Step 33:
- how to work with terraform state: Backend Authentication-
- we know that the standard way that terraform uses is that he sotre the state file "terrafrom.tfstate" in ht errot directory, it is not a technical requirement to mention that inside the "terraform.tf" file, it's up to us
- and if we want to change that default/standard location we can go there and change it into another location
- see the attached pdf file for more details
- what we are goign to do:
    - task 1: Authentication: S3 Standard Backend
        - in this example we want to allow terraform to save our state (file) into an aws resource wichi is s3-bucket
        - so we need to configure that; so we go to  the "terraform.tf" file and add the "backend" argument --> that's how to configure
        - then we need to provide access to our s3-bucket --> there are many ways to provide credentials to enable connection to any resources (we san this before in previous labs):
            - we can hardcode it --> not recommended
            - we can use environment variables (with the xport command)
            - we can use a aws credentials file
        - we are going to use the export command (already in use in the course)
        - then we need to run "terraform init -reconfigure" to switch the location of our state file --> by doing this, we had validated that now he have access into our new s3-bucket
        - then run "apply" --> this weill put some data inside our new s-bucket --> because terraform will use it to store the state there (we can check with the aws console)
    - task 2: Authentication: Remote Enhanced Backend
        - how to limit access to being able to query this information (meaning the data inside the s-bucket)
        - we can use the command "terraform login" after creating a terraform cloud account, then we go to our account and generate a tocken --> paste/use it after running the command "terraform login"