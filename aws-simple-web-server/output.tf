output "public_ip" {
value = aws_instance.first-instance.public_ip
description = "The public IP of the web server"
}
