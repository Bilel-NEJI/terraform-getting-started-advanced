# This is the explanation file for the folder "terraform16":


## Step 20: ("amin.tf" file)
- how to work with Terraform Provisioners
- see more details in the attached pdf
- until this point, we have an EC2 web server that we have created but still useless/not really usefull, in fact it's just a bear-bone operating system running within a virtual machine
- so we are going to leverage terraform provisioners now to give the server a purpose and deploy an application to it
- but before deploy our application we need to run some security updates as well and we will leverage terraform provisioners to take these actions
- now terraform has a number of different provisioners that can be used; we can execute commands locally using the "local-exec" and remotly using a virtual machine with the remote-exec provisioner
- whar we are going to do:
    - task 1: Upload your SSH keypair to AWS and associate to your instance --> to allow terraform our to connect into our remote machine
        - for that we are going to add resource block which will actually create an AWS key pair
    - task 2: Create a Security Group that allows SSH to your instance
    - task 3: Create a connection block using your SSH keypair
    - task 4: Use the "local-exec" provisioner to change permissions on your local SSH Key
    - task 5: Create a "remote-exec" provisioner block to pull down and install web application
    - task 6: Apply your configuration and watch for the remote connection.
    - task 7: Pull up the web application and ssh into the web server (optional)
        - command to shwo case the ip address of our server: "terraform state show aws_instance.ubuntu_server"
        - then connet to my ubunti instance; issue/run the ssh command; write in the terminal: ssh -i MyAWSKey.pem ubuntu@18.209.228.49 --> ssh the key with username (ubuntu) on the public ip that we got from the deployed server