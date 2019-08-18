This example code will create a mysql instance, a cluster of web servers and can be access via load balancer.
This example code will output the information of load balancer and database instance.

## FILE LAYOUT 
- global
  - s3-prod-state.tf
- prod
  - main.tf
  - outputs.tf
- modules
  - webserver-cluster/
    - main.tf
    - outputs.tf
    - variables.tf
  - mysql/
    - main.tf
    - outputs.tf
    - variables.tf

## CREATE S3 BUCKET AND STORE TERRAFORM STATE ON S3 

From cmd console, or ssh consle, navigate to global folder
- C:\Terraform\global>terraform init
- C:\Terraform\global>terraform apply

## CREATE PROD ENVIRONMENT

From cmd console, or ssh consle, navigate to prod folder
- C:\Terraform\prod>terraform init
- C:\Terraform\prod>terraform apply
