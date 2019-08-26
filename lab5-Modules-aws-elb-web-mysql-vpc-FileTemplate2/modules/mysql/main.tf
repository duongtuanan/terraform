
# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version 		= ">= 0.12"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE MYSQL INSTANCE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_db_instance" "mysql-db" {
  identifier_prefix   	= "anduong-"
  engine              	= "mysql"
  allocated_storage   	= var.db_size
  instance_class      	= var.instance_class
  name                	= var.db_name
  username            	= var.db_username
  password            	= var.db_password
}

