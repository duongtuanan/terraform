resource "aws_instance" "first-instance" {
  ami                    	= "${var.ami}"
  instance_type          	= "t2.micro"
  key_name 					= "${var.ec2-key}"
  vpc_security_group_ids 	= [aws_security_group.public-web-server.id]  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF  
   tags = {
    Name = "srv-1"
  }
}
