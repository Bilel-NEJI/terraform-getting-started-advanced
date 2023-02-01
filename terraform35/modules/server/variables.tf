# Step 29 | task 1:
# here we bringed the variables, it's the logic of the best practice / the pattern that we talked about
# Step 29 | task 2: Required and Optional Module inputs
# we say that if a varaible has default argument, we consider that varaible as "optional" --> the variable "size" is optional
# so by consequence the other ones are required
# we can see that in our configuration file ("main.tf" file), that the mdoule "server" has only 03 inputs that are needed to pass into this module
# so in order to make that optional variable to become a required variable, we only have to comment that default argument
# and of course if we have a required argument, we have to define it in the module of the "server" module under the root directory (not the "server" folder), otherwise an error will occur --> so we
variable "ami" {}

variable "size" {
  # if we want to make the "size" vairable required other than optional, we only remove the "default" argument or comment it
  # and yes! if we choose to make it required, after commenting the "default" argument, it will remain empty
  # default = "t2.micro"
}
variable "subnet_id" {}

variable "security_groups" {
  type = list(any)
}