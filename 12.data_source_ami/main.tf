#----------------------------#
# My Terraform               #
# Find lattest AMI id of:     #
# Ubuntu                     #
# Amazon Linux               #
# Windows Server             #
#----------------------------#
provider "aws" {
    region = "us-east-1"
}

data "aws_ami" "lattest-Ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}
data "aws_ami" "lattest-AmazonLinux" {
  owners = ["137112412989"]
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-*-kernel-6.12-x86_64"]
  }
}
data "aws_ami" "lattest-WindowsServer" {
  owners = ["801119661308"]
  most_recent = true
  filter {
    name = "name"
    values = ["Windows_Server-2025-English-Full-Base-*"]
  }
}






output "id_of_lattest_Ubuntu_ami" {
  value = data.aws_ami.lattest-Ubuntu.id
}
output "name_of_lattest_Ubuntu_ami" {
  value = data.aws_ami.lattest-Ubuntu.name
}
output "id_of_lattest_AmazonLinux_ami" {
  value = data.aws_ami.lattest-AmazonLinux.id
}
output "name_of_lattest_lattest-AmazonLinux_ami" {
  value = data.aws_ami.lattest-AmazonLinux.name
}
output "id_of_lattest-WindowsServer_ami" {
  value = data.aws_ami.lattest-WindowsServer.id
}
output "name_of_lattest_lattest-WindowsServer_ami" {
  value = data.aws_ami.lattest-WindowsServer.name
}
