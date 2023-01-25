# Step 13:
# create the module block
# then add an output block to export the outputs from that module
# then run "terraform init" to download this module for us (locally)
# then run "terraform apply" so it will be able to call this module, pass in this information 
# and module will to w few things with this information, it will output data back to our parent module and we are goign to output that data to the CLI (using the output)
#  so it is taken out input "10.0.0.0/22" and creating two subnets out of that
# this module block is to call a stored module that is stored in the terraform module registry to complete a few simple tasks around something that we may use for subnets
# there is an entire section specific for the module in the upcoming lessons
module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"
  version = "1.0.0"

# just bellow we have two inputs that we are passing into this module (base_cidr_block & networks which is a map of different values)
  base_cidr_block = "10.0.0.0/22"
  networks = [
        {
          name = "module_network_a"
          new_bits = 2
        },
        {
          name = "module_network_b"
          new_bits = 2
        },
    ]
}

# we are using the output (we didn't talk about it yet, until this phase) to just export informations generated from that module and then we can export it into the CLI so we can easily see the results of what this module did for us
output "subnet_addrs" {
  value = module.subnet_addrs.network_cidr_blocks
}