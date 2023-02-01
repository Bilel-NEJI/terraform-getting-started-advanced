# This is the explanation file for the folder "terraform36":


## Step 40:
- we are going to deep dive into local variables
- locals are used to:
    - make us avoid repeating our selves
    - we can have local variables that refer to other local variables
- see the .pdf for more details 
- whar we are going to do:
    - task 1: Create local values in a configuration block
        - only add a new locals block with three locals
    - task 2: Interpolate local values (this we already did in previous lab)
        - we go to the EC2 instance web_server to add the new three locals and use them in the tags
    - task 3: Use locals with variable expressions
        - so for our example we are going to add one more locals block
    - task 4: Use locals with terraform expressions and operators