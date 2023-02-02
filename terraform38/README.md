# This is the explanation file for the folder "terraform38":


## Step 42:
- we are going to deep dive into using terraform outputs
- output can do queries for spevific values that we are using our terraform configurations and ouput those for consumption later on. and that consumption later on, we just need to look at in the cli, or (as we learned in the modules section) that output maybe used as "input" for other modules that we are using or other terraform runs
- see the .pdf for more details 
- whar we are going to do:
    - task 1: Create output values in the configuration file
        - we are going to add an output to our configuration --> so we go the file "outputs.tf"
        - we want to output our pubic ip address of our web server
        - for that we create an outout called "public_ip"
        - then "validate"
        - then "apply"
    - task 2: Use the output command to find specific values
        - also we can use the command "terraform output" to see all our outputs
        - also we can use the command "terraform output public_ip" to see a specific output
        - also we can wrap up the output query to ping this record if we want to using the command: ping $(terraform output public_ip) --> by doing that our machine/pc will start to ping that ip address of pour public server (we don't have a security group on our web server that is going to allow ICMP inbound, so it's probably is going to fail)
    - task 3: Suppress(hide) outputs of sensitive values in the CLI
        - when we don't want to show some data in thc console (demo or public event)
        - in this case we are going to add an output of our "arn" (which is an amazon resource name); with the argument "sensitive = true" of course
        - the arn includes the account number of an account that we are working in, and most of the time we want to keep that information private
        - so we are going to obfuscate/hide the value inside the cli/terminal --> we need to keep in mind that's the only place to hide this value (it's still going to write the value in state (we still can read it inside our state file))
        - so run "apply"
        - so here in the terminal we will see the value of that output hiden "<sensitive>"
        - but if we want to show that value and keep the argument sensitive as true, we can of course run "terrafom output name_of_the_output"