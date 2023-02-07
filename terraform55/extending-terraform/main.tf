# Step 59 | task 1: Random Generator
# here we create a resource to generate random "password" with an outout block to show/display it in the terminal if we need so
# if we want to generate a new password in each apply we need to add the argument/parameter "keepers"
resource "random_password" "password" {
  keepers = {
    datetime = timestamp()
  }
  length  = 16
  special = true
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}

# the 2nd random component with an output block to show it inside the termianl
resource "random_uuid" "guid" {
}

output "guid" {
  value = random_uuid.guid.result
}

# Step 59 | task 2: SSH Public/Private Key Generator
resource "tls_private_key" "tls" {
  algorithm = "RSA"
}

resource "local_file" "tls-public" {
  filename = "id_rsa.pub"
  content  = tls_private_key.tls.public_key_openssh
}

resource "local_file" "tls-private" {
  filename = "id_rsa.pem"
  content  = tls_private_key.tls.private_key_pem

  provisioner "local-exec" {
    command = "chmod 600 id_rsa.pem"
  }
}

# Step 59 | task 3:
