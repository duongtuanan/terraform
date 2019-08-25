# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
} 		

variable "ec2-key" {
	type        = string
} 					

variable "server_port" {
	description = "The port the server will use for HTTP requests"
	type        = number
	default     = 8080
}

variable "elb_port" {
  description = "The port the ELB will use for HTTP requests"
  type        = number
  default     = 80
}


