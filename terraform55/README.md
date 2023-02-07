# This is the explanation file for the folder "terraform55":


## Step 59:
- we are going to see extending terraform - Non-Cloud Providers
- see the .pdf file for more details
- what we are going to do :
    - task 1: Random Generator (a random provider)
        - we add a new folder called "extending-terraform"
        - and inside of it we create a file called "main.tf"
        - then in the terminal we switch to that directory == that's means that we are making that directory our root directory
        - then we start looking for the random password generator == create a random password --> by adding th resource "password" of type "random_password"
        - then we output that by adding output block called "password"
        - then "terraform init"
        - then "terraform providers" --> we should see that we go the random provider
        - then "apply"
        - then we add another random component called "guid" of type "random_uuid"
        - then we apply
        - if we want to generate a new password in each apply we need to add the argument/parameter "keepers"
    - task 2: SSH Public/Private Key Generator (a tls provider + local provider)
        - so we are going to add another resource to our terraform configuration file
        - the "init" for install the new provider
        - then "terraform providers" --> we should see that we go the random provider
        - then "apply"
        - then "terraform show" --> we can see that by using the tls provider, we have got a public key and a private key
        - we want to output that out of state and into our file system --> so we are going to use another provider called the "local_file_provider"
        - this local file resource is going to allow us to be able to save a local file
        - and we are going to call that file "id_rsa.pub"; and its content is going to be the public key that have been created using tls provider
        - we are alos going to create a private key called "id_rsa.pem"; its content is goping to be "the private key that was generated using the tls provider". and we are going to use a local-exec provisioner to be able to change the permission of that key to something that's appropriate
        - then "init" (since we have a new provider type)
        - then "apply" --> now we have two files generated: public and private key
    - task 3: Cleanup