# Step 27 | task 1: Create a local Terraform module
# after creating this .tf file we neeto to tell terraform to utilize it by going to the "main.tf" file and do some work there (to include a module block)
variable "ami" {}

variable "size" {
  default = "t2.micro"
}
variable "subnet_id" {}

variable "security_groups" {
  type = list(any)
}
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

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "public_dns" {
  value = aws_instance.web.public_dns
}