# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A WEBSERVER CLUSTER USING THE WEBSERVER-CLUSTER MODULE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "s3-prod-state-shared-2019"
    key            = "global/s3/terraform-prod.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

# ------------------------------------------------------------------------------
# DEPLOY THE WEBSERVER-CLUSTER MODULE
# ------------------------------------------------------------------------------

module "webserver_cluster" {
  source = "../modules/webserver-cluster"

  cluster_name  = "webservers-ps"
  instance_type = "t2.micro"
  min_size      = 1
  max_size      = 2
  ami			= "ami-07d0cf3af28718ef8"
  ec2-key		= "ec2"
  server_port	= 8080
  elb_port		= 80
  
}

# ------------------------------------------------------------------------------
# DEPLOY MYSQL
# ------------------------------------------------------------------------------

module "mysql" {
  source 			= "../modules/mysql"

  db_name  			= "mysqltesting123"
  instance_class 	= "db.t2.micro"
  db_size      		= 5
  db_username		= "admin"
  db_password		= "Abc.123Anduong"
  
}
