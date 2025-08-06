provider "aws" {
	access_key = ""
	secret_key = ""
	region     = "eu-central-1"
	
}

resource "aws_instance" "my_ubuntu" {
    count = 3
	ami           = "ami-00c8ac9147e19828e"
	instance_type = "t3.micro"
	
	tags = {
    	Name    = "MKA-Ubuntu"
		Owner   = "Maksim.K"
		Project = "Terraform Lessons"
  }
}


resource "aws_instance" "my_amazon" {
	ami           = "ami-0229b8f55e5178b65"
	instance_type = "t3.small"
	
	tags = {
    	Name    = "MKA-Amazon"
		Owner   = "Maksim.K"
		Project = "Terraform Lessons"
  }
}