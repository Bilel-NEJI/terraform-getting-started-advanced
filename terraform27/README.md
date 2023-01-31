# This is the explanation file for the folder "terraform27":


## Step 31:
- how to work with terraform public Module which helps you to consume terraform modules from others
- see the attached pdf file for more details
- what we are goign to do:
    - task 1: Consuming Modules from the Terraform Module Registry (that we did in previous lab)
        - in this lab's case let's look at an S3 public module --> so we go and look for "s3-bucket" module
        - then copy that module and utilize it, of course we need to return an output from that module
    - task 2: Exploring other modules from the Terraform Module Registry
        - for example we are going to use the vpc module
        - so we look for a "vpc" module
        - then we copy and paste the provision instruction (the code)
        - this super valuable because what we have had to do in the past is to create all of these resources by ourselves, directly within our configuration
        - and now through the use of a module, we can simplify this by letting the module do it for us
    - task 3: Publishing to the Terraform Public Module Registry
        - see the details in the .pdf file