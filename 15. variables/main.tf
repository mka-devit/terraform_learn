# Провайдер AWS
provider "aws" {
  region = var.region
}
# Получаем список доступных зон
data "aws_availability_zones" "working" {}
# Получаем последнюю версию Amazon Linux 2023 AMI с ядром 6.12
data "aws_ami" "latest_AmazonLinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.12-x86_64"]
  }
}
# Получаем default VPC
data "aws_vpc" "default" {
  default = true
}
# Security Group для Web-сервера
resource "aws_security_group" "MyWebServerSG" {
  name   = "MyDynamicSG"
  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common-tags, {
    Name = "SecurityGroup",
  })
}
# EC2-инстанс
resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.latest_AmazonLinux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.MyWebServerSG.id]
  monitoring = var.detailed_monitoring

  tags = merge(var.common-tags, {
    Name = "MyWebServer",
  })
}
# Elastic IP, привязанный к инстансу
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_server.id
  tags = merge(var.common-tags, {
    Name = "MyStaticIP", 
  })
}