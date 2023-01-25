# Step 14 | task 1:
# this a static example of an output
output "hello-world" {
  description = "Print a Hello World text output"
  value = "Hello World"
}

# Step 14 | task 1:
# this output example will go and grab the vpc id from our account and export as we want
output "vpc_id" {
  description = "Output the ID for the primary VPC"
  value = aws_vpc.vpc.id
}

# Step 14 | task 2:
# this is going to be the public url for our web server
output "public_url" {
  description = "Public URL for our Web Server"
  value = "https://${aws_instance.web_server.private_ip}:8080/index.html"
}

# Step 14 | task 2:
# it will be an output inormation of our environment
output "vpc_information" {
  description = "VPC Information about Environment"
  value = "Your ${aws_vpc.vpc.tags.Environment} VPC has an ID of ${aws_vpc.vpc.id}"
}