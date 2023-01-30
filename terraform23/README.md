# This is the explanation file for the folder "terraform23":


## Step 27:
- how to work with terraform modules
- see the attached pdf file for more details
- terraform modules are the main way to package and re-use resource configuration within terraform
- this makes our code easier to read, reusable across our organization/company
- it's simple, it's really just a set of any terraform configuration files
- it allows to organize those organization files, be able to reuse them, to provide consistency and ensure best practices when utlizing those configuration files
- during all the previous steps, we were working with the route module, our working directory all throughout this course, so terrafor will naturally look to the existing .tf files
- so how we can include the configuration files that will be there; inside the modules under the root module --> the answer is terraform modules
- so now we go to the 1st task; create a local terraform module
- what we are goign to do:
    - task 1: Create a local Terraform module
        - we create a new subdirectory called "server"
        - inside that "server" folder, we create a new terraform configuration file called "server.tf"
        - so now our default working directory is "/terraform23", so terraform naturally will not look inside the content of "server" folder (terraform only looks for .tf under the working directory)
        - now let's put some content inside our "server.tf" file
        - after adding some resources there, we need to tell terraform to utilize that "server.tf" file --> so we go to our "main.tf" file and inside of it, we need to updated it to utilize that module "server" (and its configuration file "server.tf" file); so we creata a module block 
        - then after that we need to install this module/make terraform aware of it, we do that by running "terraform init"
        - to check so, we can run "terraform providers"
        - and to use it, we run "terraform apply"; by doing that we can see that terraform is creating a new server using our server module
        - we can run "terraform state list" to see the resource
    - task 2: Reference a module within Terraform Configuration
        - we put two items in our "main.tf"; two outputs
        - those are going to be the public ip and the public dns infoamtion of the server that was built using our module
        - then we apply that change
    - task 3: Terraform module reuse
        - one of the benefits of using modules, is the ability to reuse them
        - so let's got ahead and add another server using a module
        - so we go to the "main.tf" file and add a enw module block, puit inside the public subnet 1 --> then install the second module "server_subnet_1" --> "terraform init" then "apply"
        - this way we keep our code clean and consistent
        - then of course we can add our two outputs