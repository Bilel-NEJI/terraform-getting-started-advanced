# This is the explanation file for the folder "terraform10":


## Step 14:
- we can refer to the attached pdf, it has all the details
- what we are going to do:
    - task 1: Add Output Block to Export Attributes of Resources
        - so we are going to create our new file "output.tf"; in which we should find all our outputs for our configuration file. this is not neccesserary required, so if we want we can put them in "main.tf" or somewhere else.
        - then we create the two outputs, by the way outputs can be static values, can be values that we grab from other resources like attributes exported by other attributes or we can do a combination of the two which we are going to do in task 2
        - we can use outputs to pass values from module to module
        - then we run "terraform validate/plan/apply"
        - by doing this we will have no changes, and we will see the displayed two outputs
    - task 2: Output Meaningful Data using Static and Dynamic Values ==> we are going to ombine some of these
        - some time these outputs are just for us to see in the CLI, and sometimes they are for the consumption of other modules
        - so we are going to add two new lines:
            - output "public_url"
            - output "vpc_information"
        - then we run "terraform validate/apply"; we will not have changes but we will have 02 more outputs in the CLI
    - task 3: we can also export these outputs to a machine format by exporting a json fomat --> so it more machien readable (in the CLI) using the command "terraform output -json"
        - also we can run "terraform output" to see the outputs directly (note if we have some sensitives values, they will not shown in the CLI with this command)
