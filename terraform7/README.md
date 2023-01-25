# This is the explanation file for the folder "terraform7":


## Step 11:
- Data sources are used in Terraform to load or query data from APIs or other Terraform workspaces. You can use this data to make your project’s configuration more flexible, and to connect workspaces that manage different parts of your infrastructure. You can also use data sources to connect and share data between workspaces in Terraform Cloud and Terraform Enterprise.
- To use a data source, you declare it using a data block in your Terraform configuration. Terraform will perform the query and store the returned data. You can then use that data throughout your Terraform configuration file where it makes sense.
- so it is to bring some data from an API and use inside our configuration files
- what we are going to do is:
    - task 1: add a new data source to query the current AWS region being used (this can be already exist in our configuration but not referencing/using it yet; which is this line {data "aws_region" "current" {}
})
    - task 2: Update the Terraform configuration file to use the new data source (to use this datasource)
    - task 3: View the data source used to retrieve the availability zones within the region
    - task 4: Validate the data source is being used in the Terraform configuration file
    - task 5: Create a new data source for querying a different Ubuntu image
    - task 6: Make the aws_instance web_server use the Ubuntu image returned by the data source