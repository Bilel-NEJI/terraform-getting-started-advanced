# This is the explanation file for the folder "terraform40":


## Step 45:
- we are going to continue talking about variables one step further; terraform collections and structure Types
- to reduce execution effort in each terminal run we are going to comment the "local_file" block (just to run the execution faster), also comment all the location where that "local_file" is being used (inside the "main.tf" file)
- our work here will be basicly in "main.tf" and variables
- see the .pdf for more details 
- whar we are going to do:
    - task 1: Create a new list and reference its values using the index
        - we are going to create a new variable; a list type (inside the "variables.tf" file)
        - we are going to access by each of these string (inside the created variable)
        - then we go to "main.tf" and create a new resource which is going to reference our new variable "us-east-1-azs"
    - task 2: Add a new map variable to replace static values in a resource
    - task 3: Iterate over a map to create multiple resources
    - task 4: Use a more complex map variable to group information to simplify readability
        - to improve our list_subnet so we don't use static values (like in the cidr_block = "10.0200.0/24")
        - we are going back to our "variables.tf" and add another variable (a map this time) called "ip", this variable has two default values, so if we call specificly for "prod", we get a specific value and if we call for "dev" we get the other one
        - in this map we can grab the key if we want, also we can grab the value if we want to
        - so we go back to "main.tf" and modify the resource "list_subnet" to work with the map (by using the "envorinment" variable that we already have)
        - so after removing all the hardcoding from our resource, we can do another improvement which is about making our resource can take dev at a time and also dev a time
        - what we want to do next is to improve the "availability_zone" to iterate/take different idex inside that string list
        - so we need to work on that; we want to deploy subnet accross different availabilty zones (meaning removing the "availability_zone = var.us-east-1-azs[0]")
        - so we go back to "variables.tf" to add a variable called "env"; it's going to be a map of map, a map inside another map. inside of it we will put "ip" and "az"
        - then we go back to the "main.tf" to use that "env" variable
        - 