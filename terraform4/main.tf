# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  # method 1:
  # access_key = "blablablablabla"
  # secret_key = "blablablablablablablablablabla"
  # method 2:
  # to run in the terminal the commands: export AWS_ACCESS_KEY="blablablabla" & export AWS_SECRET_KEY="blablablablablablablabla"
  # method 3:
  shared_credentials_files = "/users/bilen/.aws/creds"
  profile                  = "bileln-us-east-1"
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

# adding a new resource block
resource "aws_instance" "web" {
  ami                    = "ami-01cc34ab2709337aa"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnets["public_subnet_1"].id
  vpc_security_group_ids = ["sg-0f19288ccf5a47cc3"]

  tags = {
    "Terraform" = "true"
  }
}

# Step 8 | task 2: add two new resource
# Step 8 | task 5: update the amazon s3 bucket to use the random id
resource "aws_s3_bucket_acl" "my-new-S3-bucket" {
  # task 2: is like this
  # bucket = "my-new-tf-test-bucket-bilel"

  # task 5: like this (update) --> then "terraform plan" --> "terraform apply"
  bucket = "my-new-tf-test-bucket-${random_id.randomness.hex}"
  tags = {
    Name = "My S3 Bucket"
    Purpose = "Intro to Resource Blocks Lab"
  }
}
resource "aws_s3_bucket_acl" "my_new_bucket_acl" {
  bucket = aws_s3_bucket.my_new_bucket_acl.id
  acl    = "private"
}

# Step 8 | task 3: create a new aws security group
resource "aws_security_group" "my-new-security-group" {
  name = "web_server_inbound"
  description = "Allow inbound traffic on tcp/443"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allow 443 from the Internet"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
  Name = "web_server_inbound"
  Purpose = "Intro to Resource Blocks Lab"
  }
}

# Step 8 | task 4: configure a resource from the random provider
# since we didn't define any new provider for this random resource, we need to run "terraform init" before "terraform plan/apply"
# when running "terraform init" terraform will download the plugin by him self
resource "random_id" "randomness" {
  byte_lenght = 16
}