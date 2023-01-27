# Step 23:
/*
Name: IaC Buildout for Terraform Associate Exam
Description: AWS Infrastructure Buildout
Contributors: Bryan and Gabe
*/

# Step 23 | task 2: Prepare for a Terraform Import
# so we need to prepare our configuration file; we know that the manually created resource (without terraform: task 1) should be created in some region which "us-east-2" in this case, for this we need to make sure to that we mention the right region
# then we go to the buttom of this "main.tf" file and continue the preparation by adding the following part of code
provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      Owner       = "Acme"
      Provisioned = "Terraform"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

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

# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
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

# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "ubuntu_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnets["public_subnet_1"].id
  security_groups             = [aws_security_group.vpc-ping.id, aws_security_group.ingress-ssh.id, aws_security_group.vpc-web.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated.key_name
  connection {
    user        = "ubuntu"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }

  # Leave the first part of the block unchanged and create our `local-exec` provisioner
  provisioner "local-exec" {
    command = "chmod 600 ${local_file.private_key_pem.filename}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /tmp",
      "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp",
      "sudo sh /tmp/assets/setup-web.sh",
    ]
  }

  tags = {
    Name = "Ubuntu EC2 Server"
  }

  lifecycle {
    ignore_changes = [security_groups]
  }


}

# Terraform Resource Block - Security Group to Allow Ping Traffic
resource "aws_security_group" "vpc-ping" {
  name        = "vpc-ping"
  vpc_id      = aws_vpc.vpc.id
  description = "ICMP for Ping Access"
  ingress {
    description = "Allow ICMP Traffic"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ip and ports outboun"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "MyAWSKey.pem"
}

resource "aws_key_pair" "generated" {
  key_name   = "MyAWSKey"
  public_key = tls_private_key.generated.public_key_openssh
}

resource "aws_security_group" "ingress-ssh" {
  name   = "allow-all-ssh"
  vpc_id = aws_vpc.vpc.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc-web" {
  name        = "vpc-web-${terraform.workspace}"
  vpc_id      = aws_vpc.vpc.id
  description = "Web Traffic"
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Step 22 | task 1: Manually mark a resource to be rebuilt by using the terraform "taint" command
# before doing that let's create a new web server
# then run "terraform apply" then "terrafrom state list" to check the resources
# for whatever reason, we would like to go ahead and just recreate that new web server
# we can do that by commentint out or deleting this entire resource block that we added but we don't want to modify the code here, we just want to mark that web server to be recreated next time when we execute our terraform code
# that where "terraform taint" command comes --> "terraform taint aws_instance.web_server"
# then run "terraform plan/apply"
# Step 22 | task 2: Observe a "remote-exec" provisoner failing, resulting in Terraform automatically tainting a resource (see what happens when a provisioner fails and what terraform automaticlly does, which is to taint our resource)
# so to make the provisioner fail, we will add a bad command
# Terraform Resource Block - To Build Web Server in Public Subnet
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
  security_groups = [aws_security_group.vpc-ping.id,
  aws_security_group.ingress-ssh.id, aws_security_group.vpc-web.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated.key_name
  connection {
    user        = "ubuntu"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }
  # Leave the first part of the block unchanged and create our `local-exec` provisioner
  provisioner "local-exec" {
    command = "chmod 600 ${local_file.private_key_pem.filename}"
  }
  provisioner "remote-exec" {
    inline = [
      # Step 22 | task 2: this the bad command to make the provisioner fail; this to tell terraform that the install of the web application was not clean
      # then we need to rebuild our "server" using the "terraform taint aws_instance.web_server"
      # since we did put an error by purpose, terraform will throw an error when the server is being built
      # so the result is that terraform will mark this re-built server as "tainted" (when we run "terraform state show aws_instance.web_server") because the remote exec provisioner throwed an error
      # so if it can not successfully deploy a resource, it'll automatically taint it ti tell future execution plans that it needs to recreate because it can't really trust that it's created the right way
      # if we run "terraform plan" we will see that terraform will replace that resource since it was not created successully in the previsous time
      # Step 22 | task 3: Untaint a resource
      # of course you can untaint that resouce if you don't want that resource to be replaced using the command "terraform untaint aws_instance.web_server"
      # Step 22 | task 3: Use the "-replace" option rather than "taint"
      # to show case this we should clean our code by removing the bad command "exit 2" then we run the "terraform apply -replace="aws_instance.web_server"
      # this command tells terraform: when you run your next execution sequence, replace that resource

      # Step 22 | task 2: the line with exit 2
      "exit 2",
      "sudo rm -rf /tmp",
      "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp",
      "sudo sh /tmp/assets/setup-web.sh",
    ]
  }

  tags = {
    Name = "Web EC2 Server"
  }

  lifecycle {
    ignore_changes = [security_groups]
  }
}

# Step 23 | task 2: Prepare for a Terraform Import
# this is the second step of the preparation/to finisht the preparation
# we should have empty like this
# resource "aws_instance" "aws_linus" {

# }
# this is where we actually perfomr the import itself
# Step 23 | task 3: Import the Resource in Terraform
# using the command "terraform import aws_instance.aws_linux i-0e882C5d99743d145"; "terraform import address_of_the_resource_to_import the_id_address_which_aws_has_alreay_provided"
# see more details with the command "terraform import -help"
# now after running that import command, when we run "terraform plan" we will have too many errors (we are talking and know that the import was successful); those errors are saying that they are missing some required arguments
# some of those missiong required arguments can be/are: missing "instance_type", "ami", "launch_template"
# so if we run "terraform state list" we will find out the new imported server is already there, so we can run "terraform stat show aws_instance" to see more info regarding that resource, we will find that the imported resource indeed has an id (which is the correct ine / taken from the aws portal - the one provided by aws), it has an instance_type of t2.micro, and the ami also (in the course he didn't add the launch_template argument which is also missing)
# so we go and put inside our resource block the name of the missing arguments with their values (from the output of the command "terraform stat show aws_instance") and then run "terrafom plan" --> we will not see any errors (we will see that terraform will tells us that 01 change will be there which is related to the tags that we did assign with each resource we own) --> so then we can run "terrafrom apply"
# this is the import of an EC2 instance, we need to go to the official documentation and check how to import the S3 bucket or any other aws resource
resource "aws_instance" "aws_linux" {
  ami           = "ami-01cc34ab2709337aa"
  instance_type = "i-0e882C5d99743d145"
}