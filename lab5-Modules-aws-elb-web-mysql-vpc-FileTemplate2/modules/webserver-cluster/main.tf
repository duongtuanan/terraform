
# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version 		= ">= 0.12"
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE DATA SOURCE: Get list of availability zones
# ---------------------------------------------------------------------------------------------------------------------

data "aws_availability_zones" "all" {}

data "template_file" "provision" {
  
  template 				= "${file("${path.module}/provision.sh")}"

  vars = {
    database_endpoint 	= var.db_address
    database_name     	= var.db_name
    database_password 	= var.db_password
    region            	= var.s3_region
    s3_bucket_name    	= var.s3_bucket_name
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "web-scale" {
  launch_configuration 	= aws_launch_configuration.web-launch.id
  
  # availability_zones	= data.aws_availability_zones.all.names
  vpc_zone_identifier	= var.vpc_subnets
   
  load_balancers    	= [aws_elb.web-balancer.name]
  health_check_type 	= "ELB"
  
  min_size 				= var.min_size
  max_size 				= var.max_size
  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A LAUNCH CONFIGURATION THAT DEFINES EACH EC2 INSTANCE IN THE ASG
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_launch_configuration" "web-launch" {
  name_prefix			= "web-launch-"
  image_id              = var.ami
  instance_type         = var.instance_type
  key_name 				= var.ec2-key
  security_groups 		= [aws_security_group.allow-web-srv.id]

  user_data             = "${data.template_file.provision.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SECURITY GROUP THAT'S APPLIED TO EACH EC2 INSTANCE IN THE ASG
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "allow-web-srv" {
  name 					= "allow-web-srv"
  vpc_id        		= var.vpc_id
  
  ingress {
    from_port   		= var.server_port
    to_port     		= var.server_port
    protocol    		= "tcp"
    cidr_blocks 		= ["0.0.0.0/0"]
  }
  
  # Allow all outbound
  egress {
    from_port   		= 0
    to_port     		= 0
    protocol    		= "-1"
    cidr_blocks 		= ["0.0.0.0/0"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ELB TO ROUTE TRAFFIC ACROSS THE AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_elb" "web-balancer" {
  name               	= "web-balancer"
  
  #availability_zones  	= data.aws_availability_zones.all.names
  security_groups    	= [aws_security_group.allow-balancer.id]
  
  subnets				= var.vpc_subnets
  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 60
    timeout             = 50
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
  
  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port           	= var.elb_port
    lb_protocol       	= "http"
    instance_port     	= var.server_port
    instance_protocol 	= "http"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP THAT CONTROLS WHAT TRAFFIC AN GO IN AND OUT OF THE ELB
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "allow-balancer" {
  name 					= "allow-balancer"
  vpc_id        		= var.vpc_id
  
  # Allow all outbound
  egress {
    from_port   		= 0
    to_port     		= 0
    protocol    		= "-1"
    cidr_blocks 		= ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   		= var.elb_port
    to_port     		= var.elb_port
    protocol    		= "tcp"
    cidr_blocks 		= ["0.0.0.0/0"]
  }
}
