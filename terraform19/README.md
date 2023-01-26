# This is the explanation file for the folder "terraform19":


## Step 23:
- how can terraform manage/deal with existing resources, for that terraform has the ability to "import" those resource into his configuration --> terraform import command
- see the attached pdf file for more details
- what we are going to do:
    - task 1: Manually create EC2 (meaning created not with Terraform --> using aws portal)
        - after creating this resource (EC2 Instance) aws has actually provided us an instance ip for this vm: which it is going to be important for us in the import process
    - task 2: Prepare for a Terraform Import
    - task 3: Import the Resource in Terraform
