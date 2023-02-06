# This is the explanation file for the folder "terraform43":


## Step 47:
- we are going to work terraform built-in functions
- as we continue to work with data inside terraform, there might be times where we want to modify or manipulate data based on our needs --> for this, terraform provides us with many build-in functions
- see the .pdf for more details (also we can have a look on the built-in officiale docs)
- what we are going to do:
    - task 1: Use basic numerical functions to select data
        - we go to "variables.tf" and add a 03 new variables with random values
        - then we add new locals block inside our "main.tf"
        - then we want to see the results in some outputs, so we go down and create 02 outputs
    - task 2: Manipulate strings using Terraform functions
        - so to do so we are going to modify our vpc resource called "vpc"; we will 
    - task 3: View the use of cidrsubnet function to create subnets
        - our example, for the "private_subnets" subnet, we won't do as we used to do before; entering value manually or using for each, instead we are going to use a built-insubnet function to determine the subnet
        - the built-in function is called "cidrsubnet" function; it calculates a subnet address within given ip network address prefix (see the terraform official docs)