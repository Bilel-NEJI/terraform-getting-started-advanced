# Step 29 | task 1:
# here we bringed the outputs, it's the logic of the best practice / the pattern that we talked about
output "public_ip" {
  description = "IP Address of server built with Server Module"
  value = aws_instance.web.public_ip
}

output "public_dns" {
  value = aws_instance.web.public_dns
}

# Step 29 | task 3: Module outputs and returns
# we want to return another argument into a calling module, we can simply go ahead and add output block here
output "size" {
  description = "Size of server built with Server Module"
  value = aws_instance.web.instance_type
}