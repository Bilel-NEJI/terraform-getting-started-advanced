# This is the explanation file for the folder "terraform42":


## Step 46:
- we are going to work deeper with data blocks
- see the .pdf for more details 
- whar we are going to do:
    - task 1: Query existing resources using a data block
        - reminder: data block can go and fetch data for us, and we can use that data inside of terraform (in our "main.tf" file we already have two data blocks)
        - the 1st thing, we are going to query an existing resource using a data block
        - we know that wa can query data and grab data that's already existng, but what we want to do is go ahead and query a new s3-bucket that we are going to create
        - so we go to "aws" and create a new "s3-bucket" called "my-data-lookup-bucket-bn"
        - then we come back to our "main.tf"; we add our new data block called "data_bucket" inside "main.tf". this new datablock will fetch the data from aws for us
        - then we want that to be used inside something; inside a new resource of type "aws-iam-policy" resource. so if we create a resource we actually grab data to that new resource inside terraform
        - so we create an aws IAM policy (our new resource) and we reference our new bucket inside of this new resource
    - task 2: Export addtional attributes from a data lookup
        - Export addtional "aws-s3-bucket" attributes like "bucket_regional_domain_name", "hosted_zone_id", "region", etc (see the official aws docs) from our created data lookup "my-data-lookup-bucket-bn"
        - and we are going to output these new additional attributes (03=01 the previous "arn" attribute here we will show case + 02 new attributes)
        - for that we go and create a new 03 output inside "main.tf"