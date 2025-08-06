provider "aws" {}

resource "aws_instance" "my_amazon" {
	ami           = "ami-0229b8f55e5178b65"
	instance_type = "t3.small"
	
	tags = {
    	Name    = "MKA-Amazon"
		Owner   = "Maksim.K"
		Project = "Terraform Lessons"
  }
}

resource "aws_instance" "my_ubuntu" {
    count = 3
	ami           = "ami-0a87a69d69fa289be"
	instance_type = "t2.micro"
	
	tags = {
    	Name    = "MKA-Ubuntu"
		Owner   = "Maksim.K"
		Project = "Terraform Lessons"
  }
}