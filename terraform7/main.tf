# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Step 11 | task 3: View the data source used to retrieve the availability zones within the region
# we already have this data block
# we want to determine which availability zone is available inside our region
#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
# Step 11 | task 1: add a new data source to query the current AWS region being used
# this dataresource is specific to the aws_provider it self, not for a specific resource. but of course we can do that also
data "aws_region" "current" {}

locals {
  team        = "api_mgmt_dev"
  application = "corp_api"
  server_name = "ec2-${var.environment}-api-${var.variables_sub_az}"
}

# Step 11 | task 5: Create a new data source for querying a different Ubuntu image
# the ami_id that is going to be pulled/grabed, it will be needed when we deploy any aws resource (like aws_instance)
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

# Step 11 | task 2: Update the Terraform configuration file to use the new data source (to use this datasource)
# by adding a tag where we are going to reference our data block
#Define the VPC 
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Environment = "demo_environment"
    Terraform   = "true"
    # the new tag where we are going to reference our data block
    # meaning that this new tag will grab data from the aws_region provider, it can grab data from any other resource, not only providers
    # then we run "terraform validate/plan/apply"
    Region = data.aws_region.current.name
  }
}

# Step 11 | task 3: here we can see how we are using that data block (which availability zone is available) to go and deploy our subnet
# this way we can copy/paste this resource-code and re-use it in other place since it will find by it self an available zone inside a region
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

# Step 11 | task 3: here we can see how we are using that data block (which availability zone is available) to go and deploy our subnet
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

# Step 11 | task 5: here for example we can need to the pulled/grabed data; soo this EC2 instance will know what type of instance is goign to have, is it a windows, an ubuntu, etc
# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server" {   
  # Step 11 | task 6: for example if we want to change the ubuntu image in the data block                                # BLOCK
  ami           = data.aws_ami.ubuntu.id                          # Argument with data expression
  instance_type = "t2.micro"                                      # Argument
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id # Argument with value as expression
  tags = {
    Name  = local.server_name
    Owner = local.team
    App   = local.application
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
