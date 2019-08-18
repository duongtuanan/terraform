# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
variable "db_name" {
  description = "The name of database"
  type        = string
}

variable "instance_class" {
  description = "The type of DB Instances to run (e.g. t2.micro)"
  type        = string
}

variable "db_size" {
  description = "The disk space for database"
  type        = number
}


variable "db_username" {
  description = "Default mysql username"
  type        = string
} 		

variable "db_password" {
  description = "Default mysql username"
  type        = string
} 		

