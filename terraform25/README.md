# This is the explanation file for the folder "terraform25":


## Step 29:
- how to work with terraform modules: inputs and outputs
- we are going to work on to have diagram's principals as shown in "task 1" (see attached .pdf); since we are talking about local modules (not terraform registry modules, not github, etc)
- we want to have in each module:
    - main.tf   --> our configuration file
    - variables.tf --> to deal with inputs
    - outputs.tf --> to deal with inputs
- see the attached pdf file for more details
- what we are goign to do:
    - task 1: Refactor module using code organization principles
        - so we will start by adding addtional files in the folder "server" under "modules"; "main.tf", "variables.tf", and "outputs.tf" --> to meet the pattern that we talked about --> this file layout is a best practice when it comes to coding module
        - so no we go and remove from the existing "server.tf" (under modules/server) all the declared variables and move it under the file "variables.tf"
        - also we move from the "server.tf" file all the resources and put them under "main.tf"
        - and the outputs from "server.tf" go to the "outputs.tf" file
        - so that's leavs our "server.tf" empty
        - then "init" --> "validate" --> "plan" --> "apply "
    - task 2: Required and Optional Module inputs
    - task 3: Module outputs and returns
        - we want to see what items can a module return to a system that is calling it --> we can use output block within a module to define what items are going to be returned by that module
        - meaning that we can add a return to our "server" module by adding an output within the module
        - add a size variable within the "outputs.tf" of our "server" module
        - so if we look at the output block of our server module, the 02 items that we are going to return are the server "public ip" and the "public dns" of the server that's been built, to any item that calls this 
        - so if we want to return another argument into a calling module, we can simply go ahead and add output block (under the "outputs.tf" file)
        - then we run "apply" so we can see that new output is going to be returned which the size of our new server
    - task 4: Reference module outputs
        - meaning how we can reference modules outputs (like the one that we added "size" variable returned as an output)
        - to do so we need to use the interpolation syntax to refer to the output that's being returned by the module
        - check the example inside the .pdf file (it's already implemented)