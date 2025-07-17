#----------------------------------
#         Terraform
#
# build Web Server during bootstrap
#
#----------------------------------

provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "MyWebServerSG" {
    name        = "MyDynamicSG"

  

dynamic "ingress" {
  for_each = [ "80", "443", "8080", "1541", "9999" ]
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
    	Name    = "DynamicSG MKA-SG"
		Owner   = "Maksim.K"
}
}