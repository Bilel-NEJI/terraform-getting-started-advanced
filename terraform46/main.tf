# Step 50
/*
Name: IaC Buildout for Terraform Associate Exam
Description: AWS Infrastructure Buildout
Contributors: Bryan and Gabe
*/

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

locals {
  team        = "api_mgmt_dev"
  application = "corp_api"
  server_name = "ec2-${var.environment}-api-${var.variables_sub_az}"
}

locals {
  service_name = "Automation"
  app_team     = "Cloud Team"
  createdby    = "terraform"
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Name      = var.server_name
    Owner     = local.team
    App       = local.application
    Service   = local.service_name
    AppTeam   = local.app_team
    CreatedBy = local.createdby
  }
}

locals {
  maximum = max(var.num_1, var.num_2, var.num_3)
  minimum = min(var.num_1, var.num_2, var.num_3, 44, 20)
}

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_s3_bucket" "data_bucket" {
  bucket = "my-data-lookup-bucket-bn"
}

resource "aws_iam_policy" "policy" {
  name        = "data_bucket_policy"
  description = "Allow access to my bucket"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : "${data.aws_s3_bucket.data_bucket.arn}"
      }
    ]
  })
}

#Define the VPC 
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = upper(var.vpc_name)
    Environment = upper(var.environment)
    Terraform   = upper("true")
  }

  enable_dns_hostnames = true
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

  # this is commented to gain some time when we run the execution inside the terminal
  # Leave the first part of the block unchanged and create our `local-exec` provisioner
  # provisioner "local-exec" {
  #   command = "chmod 600 ${local_file.private_key_pem.filename}"
  # }

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

# this is commented to gain some time when we run the execution inside the terminal
# resource "local_file" "private_key_pem" {
#   content  = tls_private_key.generated.private_key_pem
#   filename = "MyAWSKey.pem"
# }

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

# Terraform Resource Block - To Build Web Server in Public Subnet
resource "aws_instance" "web_server" {
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

  # this is commented to gain some time when we run the execution inside the terminal
  # Leave the first part of the block unchanged and create our `local-exec` provisioner
  # provisioner "local-exec" {
  #   command = "chmod 600 ${local_file.private_key_pem.filename}"
  # }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /tmp",
      "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp",
      "sudo sh /tmp/assets/setup-web.sh",
    ]
  }

  # tags = {
  #   Name  = local.server_name
  #   Owner = local.team
  #   App   = local.application
  #   "Service"   = local.server_name
  #   "AppTeam"   = local.app_team
  #   "CreatedBy" = local.createdby
  # }
  tags = local.common_tags

  lifecycle {
    ignore_changes = [security_groups]
  }

}

# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server_2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnets["public_subnet_2"].id
  tags = {
    Name = "Web EC2 Server 2"
  }
}

# Step 45 | task 1: Create a new list and reference its values using the index
# creating a new resource (an aws_subnet) that is going to reference the new variable called "us-east-1-azs"
# this resource is going to look to our variable and it's going to grab an availabilty zone from the created variable (the list of strings), we will see how to do it
# then "plan" --> we will get en error, because of: the "availability_zone" is expecting a single string while our new variable has a list if strings
# so we should add something to the argument that grabs the variable
# so we added "[0]" (look bellow) to grab the 1st one
# the "plan" --> all good in the terminal output
# then "apply"
# Step 45 | task 2: Add a new map variable to replace static values in a resource
# we come here to improve the situation and work with the map to avoid static values
# so we modify the "cidr_block" argument
# we are going to use the "prod" value (even with this "prod", we are still hardcoding the key but not the value)
# then "plan"
# then "apply"
# so to remove the key "prod" hardocing also, we can use the variable that we already have "environment" (in the file "variables.tf")
# this "environment" variable has a default string value equal to "dev", but of course we can add what we want, but we will stick with "dev" and "prod"
# so we go to the line of cidr_block again and replace the hardcoded part ("prod") with that "environment" variable
# then "plan"
# then "apply"
# also we can do another improvement
# we want to be able to iterate over our map and create a subnet fo reach key inside of our map: at a time it get prod and also it can take dev at a time
# so we go and modify "cidr_block" once again
# so we use a "for_each" loop
resource "aws_subnet" "list_subnet" {
  # adding the "for_each" loop: meaning for each value, or for each key of our map, go and execute what is written bellow it
  # the "for_each" loop will create one subnet for each one using these 03 parameters, but for each value that's inside of our map
  # meaning for each key inside of our map (prod, dev), go create a subnet using the same vpc_id, and when you get to the cidr_block for each one look at the value of each key and use that as our cidr_block --> so two subets in total
  # then "plan"
  # then "apply"
  # also we can use the "each.key" as we used "each.value"
  # we can add it to add tags
  for_each = var.ip
  vpc_id   = aws_vpc.vpc.id
  # before task 2
  # cidr_block        = "10.0.200.0/24"

  # in task 2: changes to use the map called "ip" (not fully hardcoded)
  # cidr_block        = var.ip["prod"]

  # in task 2: changes to use the map called "ip" (fully hardcoded)
  # cidr_block        = var.ip[var.environment]

  # here how it becomes when we use for_each
  cidr_block = each.value

  # how was written before error meesage ("plan")
  # availability_zone = var.us-east-1-azs
  # how to write it to correct the situation and only bring one string; knowing that the 1st index of a list is a "0"
  availability_zone = var.us-east-1-azs[0]

  # adding tag and using the "for_each" loop
  tags {
    Name = each.key
  }
}

resource "aws_subnet" "list_subnet" {
  # for_each = var.ip
  for_each          = var.env
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.ip
  availability_zone = each.value.az
  tags {
    Name = each.key
  }
}

# Step 48 | task 3: Convert Security Group to use dynamic block
# this locals block define a set of rules for both ports 443 and 80, and then we are going to refactor the aws-security-group t omake use of a dynamic block
# in task 5: we will not use this locals, instead we will use the variable to define the ruleset for our security group
# locals {
#   ingress_rules = [{
#     port        = 443
#     description = "Port 443"
#     },
#     {
#       port        = 80
#       description = "Port 80"
#     }
#   ]
# }


# Step 50 | task 1: Use "create_before_destroy" with a simple AWS security group and instance
# then we are going to make a change to our aws security_group
# we are going to change the name of our security group from "core-sg" to "core-sg-global"
# then "apply" --> error deleting security_group (see .pdf file) --> it won't successed because there is a dependecy
# to resolve this we are going to use a lifecycle directive (inside our resource) which modifies the order of operation that terraform takes for resource replacement
resource "aws_security_group" "main" {
  # the name before changing it
  # name   = "core-sg"
  # the name after changing it --> from "core-sg" to "core-sg-global"
  name   = "core-sg-global"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.web_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Step 50 | task 1: Use "create_before_destroy" with a simple AWS security group and instance
  # the step to change the default terraform behaviour; using a lifecycle directive
  # with it we say to terraform, before deleting it first, create the new resource and then destroy the old one
  lifecycle {
    create_before_destroy = true
    # prevent_destroy = true
  }
}


module "server" {
  source          = "./terraform24/modules/server"
  ami             = data.aws_ami.ubuntu.id
  size            = "t2.micro"
  subnet_id       = aws_subnet.public_subnets["public_subnet_3"].id
  security_groups = [aws_security_group.vpc-ping.id, aws_security_group.ingress-ssh.id, aws_security_group.vpc-web.id]
}

# Step 50 | task 1: Use "create_before_destroy" with a simple AWS security group and instance
# we add a new security_group "aws_security_group.main.id", the security_group which is labeled "main" into our security_group list
# then "validate" --> to make sure that we didn't write false thing
# then "apply" --> so now our server module has our new security group that's been created
# 
module "server_subnet_1" {
  source          = "./terraform24/modules/web_server"
  ami             = data.aws_ami.ubuntu.id
  key_name        = aws_key_pair.generated.key_name
  user            = "ubuntu"
  private_key     = tls_private_key.generated.private_key_pem
  subnet_id       = aws_subnet.public_subnets["public_subnet_1"].id
  security_groups = [aws_security_group.vpc-ping.id, aws_security_group.ingress-ssh.id, aws_security_group.vpc-web.id, aws_security_group.main.id]
}

output "public_ip" {
  value = module.server.public_ip
}

output "public_dns" {
  value = module.server.public_dns
}

output "size" {
  value = module.server.public_dns
}

output "public_ip_server_subnet_1" {
  value = module.server_subnet_1.public_ip
}

output "public_dns_server_subnet_1" {
  value = module.server_subnet_1.public_dns
}

# this sourcing example is with github sources
# module "autoscaling" {
# source = "github.com/terraform-aws-modules/terraform-aws-autoscaling?ref=v4.9.0"

#   # Autoscaling group
#   name                = "myasg"
#   vpc_zone_identifier = [aws_subnet.private_subnets["private_subnet_1"].id, aws_subnet.private_subnets["private_subnet_2"].id, aws_subnet.private_subnets["private_subnet_3"].id]
#   min_size            = 0
#   max_size            = 1
#   desired_capacity    = 1

#   # Launch template
#   use_lt    = true
#   create_lt = true

#   image_id      = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"

#   tags_as_map = {
#     Name = "Web EC2 Server 2"
#   }
# }

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.9.0"

  # Autoscaling group
  name                = "myasg"
  vpc_zone_identifier = [aws_subnet.private_subnets["private_subnet_1"].id, aws_subnet.private_subnets["private_subnet_2"].id, aws_subnet.private_subnets["private_subnet_3"].id]
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1

  # Launch template
  use_lt    = true
  create_lt = true

  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags_as_map = {
    Name = "Web EC2 Server 2"
  }
}

output "asg_group_size" {
  value = module.autoscaling.autoscaling_group_max_size
}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"
}
output "s3_bucket_name" {
  value = module.s3-bucket.s3_bucket_bucket_domain_name
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # here we constraint the module version
  version = ">3.11.0"

  name               = "my-vpc-terraform"
  cidr               = "10.0.0.0/16"
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Name        = "VPC from Module"
    Terraform   = "true"
    Environment = "dev"
  }
}

output "phone_number" {
  value     = var.phone_number
  sensitive = true
}

output "data-bucket-arn" {
  value = data.aws_s3_bucket.data_bucket.arn
}

output "data-bucket-domain-name" {
  value = data.aws_s3_bucket.data_bucket.bucket_domain_name
}

output "data-bucket-region" {
  value = "The ${data.aws_s3_bucket.data_bucket.id} bucket is located in ${data.aws_s3_bucket.data_bucket.region}"
}

output "max_value" {
  value = local.maximum
}

output "min_value" {
  value = local.minimum
}
