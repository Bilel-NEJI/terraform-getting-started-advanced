# This is the explanation file for the folder "terraform6":


## Step 10:
- Goal of the step: is to talk about Locals Block = Locals
- they are goign to reduce repeatative references to expressions or values
- Locals are very similar to traditional input variables and can be referred to throughout your Terraform configuration. Locals are often used to give a name to the result of an expression to simplify your code and make it easier to read
- so make it easier to update in a single place, also makes our configuration easier to read because we are going to be refering to those locals variables instead of refering to each expression of our resources
- so to define one, we are going to define it inside a locals block
- a single block can have many local variables
- we can refer to other local variables inside other locals blocks
- what we are going to do is:
    - task 1: define the name of an EC2 instance using a local variable
        - we are goign to modify our main.tf and add a locals block in there
        - and we are goig to use that locals block to update the tags of our EC2 instance
    - task 2: