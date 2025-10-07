provider "aws" {
  region = "eu-north-1"
}

resource "null_resource" "command1" {
    provisioner "local-exec" {
        command = "echo Terraform START: $(DATE +%Y-%m-%dT%H:%M:%S) >> terraform.log"
   }
}

resource "null_resource" "command2" {
provisioner "local-exec" {
 command = "ping -c 4 google.com"
    }
    depends_on = [null_resource.command3]
}

resource "null_resource" "command3" {
provisioner "local-exec" {
 command = "print('Hello from command3')"
 interpreter = [ "python3", "-c" ]
    }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = " echo $NAME $NAME1 $NAME2 >> name.txt"
    environment = {
        NAME  = "John"
        NAME1 = "Doe"
        NAME2 = "Smith"
        
    }
  }
}

resource "aws_instance" "command5" {
  ami           = "ami-0b83c7f5e2823d1f4"
  instance_type = "t3.micro"

  provisioner "local-exec" {
    command = "echo Instance ID: ${self.id} >> instance.log"
  }
}

resource "null_resource" "command6" {
    provisioner "local-exec" {
        command = "echo Terraform END: $(DATE +%Y-%m-%dT%H:%M:%S) >> terraform.log"
   }
   depends_on = [ null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4, aws_instance.command5 ]
}