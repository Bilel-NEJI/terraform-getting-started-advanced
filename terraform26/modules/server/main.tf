# Step 29 | task 1:
# here we bringed the resources, it's the logic of the best practice / the pattern that we talked about
resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.size
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups
  
  tags = {
    "Name"        = "Server from Module"
    "Environment" = "Training"
  }
}