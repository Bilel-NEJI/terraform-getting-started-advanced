# This is the explanation file for the folder "terraform30":


## Step 34:
- how to work with more configurations of standard Backend
- there many standard backend
- we should know that s3-bucket is one of those standard backend
- so here we should have an aws s3-bucket
- what we are goign to do:
    - task 1: Standard Backend: S3
        - there a lot of mechanisms that we can check:
            - one of the mechanisme that we are goign to see, is s3-bucket versioning (versioning our terraform backend)
                - this enable us to restore previous state backends
                - for this we need to have an aws account and a s3-bucket where we store our terraform state --> we need to go there and enable the option of "bucket versioning"
                - then we will go to our "main.tf" file, to the "web_server_2" resource exactly, and change the "instance_type"
                - then we go to the aws console --> our s3-bucket and toggle the button "show version" --> there we can see your versions
            - the next mechanism is "enabling encryption"
                - in our configuration/state there can be sentitive information that we want to hide --> so we need to enable encryption on our backend
                - and the s3-bucket does support this encryption (not only the s3-bucket, but there are other standard backend allow us to do so) --> and this is one of the benefit over using local backend where we store state
                - here also we need an aws account --> go to the s3-bucket and enable the "server-side encryption"
            - the next mechanism is to enable locking for s3 (which the s3 does not natively have a locking mechanism)
                - it actually has to work in conjunction with DynamoDB table to provide locking
                - so here we need to have an aws account
                - we search for dynamoDB table and create one, give it a "name" and "partition key"
                - so new let's imlement that inside our terraform configuration = meaning that we go back the "terraform.tf" file and then we need to implement some code here: "dynamodb_table" and "encrypt" (terraform block)
                - by doing this we will utilize DynamoDB to provide locks (on our s3-bucket backend = state)
                - then run "init" --> then we will see that terraform will detect the change that we made from "t2.micro" --to--> "t2.small"
                - when we go back to the aws console (still we didn't confirm with entring "yes" in the terminal when asked); into the locking table (the table that we named "terraform-locks" inside the "terraform.tf" file; under our DynamoDB table --> click on the button "view item"), we will find a lock file there doing the locking operation (same as a locking on a local file)
                - in a later stage, we will see how we can migrate backend state from backend to another
    - task 2: Standard Backend: HTTP Backend (Optional)
        - see the .pdf file
        - the http backend will allow us to be able to store state using a simple rest client
        - for this we need to create a folder called "http" (which going to be our web server to use in a later time as a location to save our state/backend as json format) and inside of it a file called "requirements.txt" and can get its content from the github repo (the github repo is for the profile "mikalstill/junkcode")
        - and another folder called "stateserver.py" and we should fill it with its content
        - then we start our web server (in which we will store our state/backend), so in the terminal we switch to the http directory and run these commands:
            - python3 -m venv ~/virtualenvs/remote_state
            - . ~/virtualenvs/remote_state/bin/activate
            - pip install -U -r requirements.txt
            - python stateserver.py
        - so then we can see that our web_server is running locally on port 5000
        - then we do to the "terraform.tf" to remove the backend "s3" and replace with the http backend; knowing that terraform can only accept a single backend
        - then "terraform init -reconfigure"
        - then "apply"