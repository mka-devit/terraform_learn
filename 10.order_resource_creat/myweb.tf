#----------------------------------
#         Terraform
#
# build Web Server during bootstrap
#
#----------------------------------

provider "aws" {
  region = "eu-north-1"
}

resource "aws_eip" "mystati_ip" {
  instance = aws_instance.my_web_server.id
}

resource "aws_instance" "my_web_server" {
  ami                    = "ami-00c8ac9147e19828e"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.MyWebServerSG.id]

	tags = {
    Name    = "MKA-web_server"
		Owner   = "Maksim.K"
}
depends_on = [ aws_instance.my_db_server, aws_instance.my_app_server ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "my_db_server" {
  ami                    = "ami-00c8ac9147e19828e"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.MyWebServerSG.id]

	tags = {
    Name    = "MKA-DB_Server"
		Owner   = "Maksim.K"
}
}

resource "aws_instance" "my_app_server" {
  ami                    = "ami-00c8ac9147e19828e"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.MyWebServerSG.id]

	tags = {
    Name    = "MKA-APP_Server"
		Owner   = "Maksim.K"
}
depends_on = [ aws_instance.my_db_server ]
}


resource "aws_security_group" "MyWebServerSG" {
    name        = "MyWebServerSG"
    description = "MySecurityGroup_to_WebServer_fromAWS"
  
dynamic "ingress" {
  for_each = [ "80", "443", "8080"]
  content{

    from_port        = ingress.value
    to_port          = ingress.value
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  
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

