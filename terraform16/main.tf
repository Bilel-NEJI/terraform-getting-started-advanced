# Step 20
/*
Name: IaC Buildout for Terraform Associate Exam
Description: AWS Infrastructure Buildout
Contributors: Bryan and Gabe
*/

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

# Terraform Data Block - Lookup Ubuntu 20.04
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

#Define the VPC 
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Environment = "demo_environment"
    Terraform   = "true"
  }
}

#Deploy the private subnets
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

#Deploy the public subnets
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

#Create route tables for public and private subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
    #nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name      = "demo_public_rtb"
    Terraform = "true"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # gateway_id     = aws_internet_gateway.internet_gateway.id
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name      = "demo_private_rtb"
    Terraform = "true"
  }
}

#Create route table associations
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public_route_table.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private_subnets]
  route_table_id = aws_route_table.private_route_table.id
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
}

#Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "demo_igw"
  }
}

#Create EIP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name = "demo_igw_eip"
  }
}

#Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_subnet.public_subnets]
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
  tags = {
    Name = "demo_nat_gateway"
  }
}

resource "random_string" "random" {
  length = 10
}

# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server" {                            # BLOCK
  ami           = data.aws_ami.ubuntu.id                          # Argument with data expression
  instance_type = "t2.micro"                                      # Argument
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id # Argument with value as expression
  tags = {
    Name = "Web EC2 Server"
  }
}


# --> Step 20 | task 3: this where we found the EC2 vm
# so we have to add a couple of items
# 1st thing we need to update our security groups with the one from the created security-group
# 2nd thing we go and associate our key to this EC2 instance
# then all set to utilize our provisioner --> so with provisioner, the next thing to set up is called the "connection block"
# so now when the server is created; a key will be associated with it and the connection block will tell terraform how to connect to this server (username, pub ip, private key)
# --> so connection blocks can no tstand on theri our, they have to be embeded in a given resource block 
# so now it's time to put in one of our terraform provisioners
# so the 1st provisioner is: a local-exec provisioner
# so the local-exec provisioner invokes a local command after a resource is created --> so the local-exec provisioner will go ahead and execute that command "chmod 600 ..." on the work station/PC that is running a "terraform apply"
# then it's time to set the 2nd provisioner; the remote-exec provisioner
# then run "terraform validate" and "terraform apply"
# 
# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "ubuntu_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
  # --> 1st thing: this one will be replaced wiht the line bellow
  # security_groups = [aws_security_group.vpc-ping.id]
  security_groups             = [aws_security_group.vpc-ping.id, aws_security_group.ingress-ssh.id, aws_security_group.vpc-web.id]
  associate_public_ip_address = true
  # --> 2nd thing: by simply add a new argument which is the "key_name" (note: the connection block will be added wiht the next sub-step)
  key_name = aws_key_pair.generated.key_name
  # this is related to the connection block
  connection {
    user        = "ubuntu"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }

  # --> 1st provisioner to put
  provisioner "local-exec" {
    # this command is to change the permissions of my private key
    # so private keys need to have a cetain permission and set to apply them before to be used to connect to a vm
    # so we are going to leverage the local-exec provisioner to make sure that the permissions are set to thte appropriate value
    command = "chmod 600 ${local_file.private_key_pem.filename}"
  }

  # --> 2nd provisioner to put
  # remember that the provision block need to be embeded into a given resource block
  # knowning that the remote-exec provisioner execute a series of commands inside the remote resource that have been created (on our server)
  provisioner "remote-exec" {
    inline = [
      # clean up the tmp directory in the server
      "sudo rm -rf /tmp",
      # go and clone down my web application inside the tmp directory
      "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp",
      # then execute a deployment script which is contained in our web application folder called "setup-web.sh"
      "sudo sh /tmp/assets/setup-web.sh",
    ]
  }

  tags = {
    Name = "Ubuntu EC2 Server"
  }

  lifecycle {
    ignore_changes = [
      security_groups
    ]
  }
}

resource "aws_subnet" "variables-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.variables_sub_cidr
  availability_zone       = var.variables_sub_az
  map_public_ip_on_launch = var.variables_sub_auto_ip

  tags = {
    Name      = "sub-variables-${var.variables_sub_az}"
    Terraform = "true"
  }
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "MyAWSKey.pem"
}

# Step 20 | task 1: Upload your SSH keypair to AWS and associate to your instance
# --> to allow terraform our to connect into our remote machine
# this resource will generate an AWS Key pair --> it actually going to use the "MyAWSKey" key that .pem file (from a prvious lab/TLS provider lab)
# then run "terraform apply"
resource "aws_key_pair" "generated" {
  key_name   = "MyAWSKey"
  public_key = tls_private_key.generated.public_key_openssh

  lifecycle {
    ignore_changes = [key_name]
  }
}

# Step 20 | task 2: Create a Security Group that allows SSH to your instance --> we need to add some security groups into our environment
# so actually we are going to leverage a terraform provisioner and specificly we are goignt to use the remote-exec provisioner
# the way that the remote-exec provisioner works is that it needs to communicate over SSH to our remote EC2 virtual machine
# --> this is why we need to add the proper security groups to allow the terrafrom provisioners to communicate to our EC2 instance
# so the way to do that; is to add an AWS security group resource block "ingress-ssh"
# also we are going to use an other security group because we are going to deploying a web application to our vm, and we want to open some web traffic "vpc_web"
# so now after that we have added two security groups; one to allow ssh traffic and the 2nd one to allow web traffic on the ports 80 + 443
# then we should look and find th resource block that creates our EC2 vm (inside this "main.tf" file) by searching for the word "ubuntu"
# --> Step 20 | task 3: 
resource "aws_security_group" "ingress-ssh" {
  name   = "allow-all-ssh"
  vpc_id = aws_vpc.vpc.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "-1"
  }
  //Terraform removes the default rule
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "vpc-web" {
  name        = "vpc.web.${terraform.workspace}"
  vpc_id      = aws_vpc.vpc.id
  description = "Web Traffic"
  ingress {
    description = "Allow Port 88"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
