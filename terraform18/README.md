# This is the explanation file for the folder "terraform18":


## Step 22:
- how to use "taint" anf "replace" cammands (when choose to re-create some of the resources that terraform has built)
- see more details in the attached pdf
- so we all go and mark our resource to be built
- before that let's create a new web server (of course a resource block)
- whar we are going to do:
    - task 1: Manually mark a resource to be rebuilt by using the terraform "taint" command
        - before doing that let's create a new web server
        - for whatever reason, we would like to go ahead and just recreate that given server (the new web server)
        - we can do that by commentint out or deleting this entire resource block that we added but we don't want to modify the code here, we just want to mark that web server to be recreated next time when we execute our terraform code
        - that where "terraform taint" command comes --> "terraform taint aws_instance.web_server"
        - then run "terraform plan/apply"
    - task 2: Observe a "remote-exec" provisoner failing, resulting in Terraform automatically tainting a resource (see what happens when a provisioner fails and what terraform automaticlly does, which is to taint our resource)
    - task 3: Untaint a resource
    - task 4: Use the "-replace" option rather than "taint" (since Terraform 15.2 the taint command was decprecated, it's replaced with "replace")