#----------------------------------
#         Terraform
#
# build Web Server during bootstrap
#
#----------------------------------

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "my_web_server" {
  ami                    = "ami-00c8ac9147e19828e"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.MyWebServerSG.id]

  user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF
	tags = {
    	Name    = "MKA-LinuxAWS"
		Owner   = "Maksim.K"
}
}


resource "aws_security_group" "MyWebServerSG" {
    name        = "MyWebServerSG"
    description = "MyWebServer_fromAWS"
  
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
}

	tags = {
    	Name    = "MKA-SG"
		Owner   = "Maksim.K"
}
}