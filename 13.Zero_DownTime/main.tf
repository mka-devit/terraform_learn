#----------------------------------------------------------
# Provision Highly Available web in any Region Defoult VPC
# Create:
# - 1 Security Group for Web Server
# - 2 Launch Configuration with Auto AMI Lookup
# - 3 Auto Scaling Group with 2 AZs
# - 4 Load Balancer in 2 AZs
# Made by:
# Makism Kotlyar
#----------------------------------------------------------
provider "aws" {
  region = "eu-north-1"
}
# Получаем список доступных зон и последней версии Amazon Linux AMI
data "aws_availability_zones" "Available" {}
data "aws_ami" "lattest-AmazonLinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.12-x86_64"]
  }
}
#----------------------------------------------------------
# Security Group for Web Server
resource "aws_security_group" "MyWebServerSG" {
    name        = "MyDynamicSG"
dynamic "ingress" {
  for_each = [ "80", "443"]
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
#----------------------------------------------------------
# Launch Configuration with Auto AMI Lookup
resource "aws_launch_template" "web" {
  name_prefix   = "WebServer-HighlyAvailable-"
  image_id      = data.aws_ami.lattest-AmazonLinux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.MyWebServerSG.id]
  user_data = filebase64("user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WebServer"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
#----------------------------------------------------------
# Auto Scaling Group with 2 AZs
resource "aws_autoscaling_group" "web_asg" {
  name                 = "ASG-${aws_launch_template.web.latest_version}"
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  vpc_zone_identifier  = [
    aws_default_subnet.default_ez1.id,
    aws_default_subnet.default_ez2.id
  ]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web_elb.name]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  dynamic "tag" {
    for_each = {
      Name   = "WebServerAutoScalingGroup"
      Owner  = "Kotlyar Maksim"
      TAGKEY = "TAGVALUE"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

#----------------------------------------------------------
# Load Balancer in 2 AZs
resource "aws_elb" "web_elb" {
    name                    = "WebServerLoadBalancer"
    availability_zones      = [data.aws_availability_zones.Available.names[0], data.aws_availability_zones.Available.names[1]]
    security_groups         = [aws_security_group.MyWebServerSG.id]
    listener {
        instance_port       = 80
        instance_protocol   = "HTTP"
        lb_port             = 80
        lb_protocol         = "HTTP"
    }
    health_check {
        target              = "HTTP:80/"
        interval            = 10
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
    tags = {
        Name  = "WebServerLoadBalancer"
    }
} 
#----------------------------------------------------------
# Defoult VPC Subnet
resource "aws_default_subnet" "default_ez1" {
  availability_zone = data.aws_availability_zones.Available.names[0]
}
resource "aws_default_subnet" "default_ez2" {
  availability_zone = data.aws_availability_zones.Available.names[1]
}
#----------------------------------------------------------
# Outputs
output "web_elb_dns_name" {
  value = aws_elb.web_elb.dns_name 
}