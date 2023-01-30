# This is the explanation file for the folder "terraform24":


## Step 28:
- how to work with terraform modules: sources
- we are going to see where we can source our configuration from
- we need to remember that terraform modules are just simply terraform configuration fiels that live outside of our working directory, in fact there can live in subdirectory (as we saw in the prvious part "terraform24"), in github repo, in s3 bucket, terraform registry, mercurial repo, gcs buckets, etc
- so in this tuto we are goign to source from 03 different sources: local module / public module registry / github
- so in the course we (they=the teacher) already deployed servral servers; we have some of them which are in our root directory, some of there servers which have come previous labs and some are come from modules themselves
- see the attached pdf file for more details
- what we are goign to do:
    - task 1: Source a local Terraform module
        - to  make things better we will go and create a new folder called "modules", then place our folder "server" under it
        - so by doing this, we need to go and update the source of where those modules are located within our module blocks
        - then a further step we go and add another directory underneath our modules directory and we are call it "web_server" and we put a content inside that directory as well (inside the new "server.tf" file)
        - this new "server.tf" file will have some changes regarding the previous one
        - then we need to go and reference the new module back in our root directory inside our "main.tf", in a relation with "server_subnet_1" module
    - task 2: Explore the Public Module Registry and install a module
        - the terraform Public Registry is an index of modules that other did share publicly --> we can call modules from those public registries
        - for example we want to add an auto scaling group into our configuration, so let's see inside of it if we can find something that can help us --> so we find an aws module specific to autoscaling, so we can go and grap its code and work with it inside our "main.tf" file --> so we go there (to the "main.tf")
    - task 3: Source a module from GitHub
        - in this case it's going to be the same aws autoscaling group
        - so of course this will replace the task 2 (from public registry), so we need to remove/comment/replace that one (or this one)
