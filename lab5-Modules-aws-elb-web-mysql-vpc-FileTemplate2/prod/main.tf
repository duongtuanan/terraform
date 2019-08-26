# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A WEBSERVER CLUSTER USING THE WEBSERVER-CLUSTER MODULE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
  
  #Remove if you want to use remote state
  #backend "s3" {
  #   bucket         = "s3-prod-state-shared-2019"
  #   key            = "global/s3/terraform-prod.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-up-and-running-locks"
  #   encrypt        = true
  #}
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  profile    		= "default"
  region     		= "us-east-1"
}

# ------------------------------------------------------------------------------
# DEPLOY THE VPC, SUBNETS, GATEWAY
# ------------------------------------------------------------------------------
module "network" {
  source 			= "../modules/network"
  cidr_vpc 			= "10.1.0.0/16"
  cidr_subnet 		= "10.1"
}

# ------------------------------------------------------------------------------
# DEPLOY THE WEBSERVER-CLUSTER MODULE
# ------------------------------------------------------------------------------

module "webserver_cluster" {
  source = "../modules/webserver-cluster"

  cluster_name  	= "webservers-ps"
  instance_type 	= "t2.micro"
  min_size      	= 1
  max_size     		= 2
  ami				= "ami-0b898040803850657"
  ec2-key			= "ec2"
  server_port		= 80
  elb_port			= 80
  vpc_id			= module.network.vpc_id
  vpc_subnets		= module.network.vpc_subnets
   
  # TESTING ONLY - For web server provisioning
  db_address		= module.mysql.db_address
  db_name  			= "mysqltesting123"
  db_password		= "Abc.123Anduong"
  s3_bucket_name	= "springboot-s3-example"
  s3_region			= "eu-west-1"
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
