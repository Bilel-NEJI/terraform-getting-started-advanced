variable "ami" {}

variable "size" {
  default = "t2.micro"
}
variable "subnet_id" {}

# Step 28 | task 1: Source a local Terraform module
# the main differences between this "server.tf" file and the previous/other one is that this has some new variables + also executing and remote-exec provision to install our web application
# we consider these changes as few enhancments with this module
# then we need to 
variable "user" { 
}

variable "security_groups" {
  type = list(any)
}

variable "key_name" {
}

variable "private_key" {
}

resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.size
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups

  associate_public_ip_address = true

  key_name = var.key_name
  connection {
    user = var.user
    private_key = var.private_key
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /tmp",
      "sudo git clone https://github.comhashicorp/demo-terraform-101 /tmp",
      "sudo sh /tmp/assets/setup-web.sh",
    ]
  }
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