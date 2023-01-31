# This is the explanation file for the folder "terraform26":


## Step 30:
- how to work with terraform Module scope
- let's have a look at our autoscaling module; here in our example we are going to look a sourcing module using terraform module registry
- if we go back to the offcial page of that aws autoscalming registry and check what is written, we wll find that we have:
    - 86 inputs (as available and could be used)
    - 20 outputs (as available and could be used)
    - 01 dependency
    - 04 resources: which the module may create
- so we run "init" --> "apply" to deploy our infrastructure and see what we got as built resources (using "terraform state list") --> we will find that our module did create (depending on the count value to have during the runtime; basing on the configuration that we passed into this module)
- 
- see the attached pdf file for more details
- what we are goign to do:
    - task 1: Resources within Child Modules
    - task 2: Scoping Module Inputs and Outputs
    - task 3: Reference Child Module Outputs
        - we need to use the interpolation syntax to refer to those outputs names that are returned to us by the module
        - so for example if we wanted to look at the autoscaling group max size, we would actually reference that by specifying module auto scaling, auto scaling group max size
        - to do that we will create an output block (under "main.tf" in the root directory)
        - module outputs are the only supported way for users to get information about resources that have been configured within a child module
        - so individual resource arguments are not accessible unless the module author or the child module has explicity allow us to return them
    - task 4: Invalid Module References
        - we can see the details in the .pdf file