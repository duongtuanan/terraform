variable "ec2-key" {
	default="EC2key"
} 					
variable "ami" {
	default="ami-07d0cf3af28718ef8"
} 		

variable "server_port" {
	description = "The port the server will use for HTTP requests"
	type        = number
	default     = 8080
}