#---------------------------------------------
provider "aws" {
    region = "eu-north-1"
    default_tags {
        tags = {
            Owner = "Maksim.K"
            CreatedBy = "Maksim.K"
        }
    }
  
}
#-----------------------------------------------------------
# Получаем список доступных зон и последнюю версию Amazon Linux AMI
data "aws_availability_zones" "working" {}
data "aws_ami" "lattest-AmazonLinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.12-x86_64"]
  }
}
#-----------------------------------------------------------
resource "aws_default_vpc" "default" {}
resource "aws_default_subnet" "default_az1" {
    availability_zone = data.aws_availability_zones.working.names[0]
}
resource "aws_default_subnet" "default_az2" {
    availability_zone = data.aws_availability_zones.working.names[1]
}
#-----------------------------------------------------------
# Security Group for Web Server
resource "aws_security_group" "MyWebServerSG" {
    name        = "MyDynamicSG"
    vpc_id = aws_default_vpc.default.id
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
#-----------------------------------------------------------
# Launch Template with Auto AMI Lookup
resource "aws_launch_template" "web" {
  name                   = "WebServer-HighlyAvailable"
  image_id               = data.aws_ami.lattest-AmazonLinux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.MyWebServerSG.id]
  user_data              = filebase64("user_data.sh")
}
#-----------------------------------------------------------
# Auto Scaling Group with Multiple Availability Zones
resource "aws_autoscaling_group" "web_asg" {
  name                 = "WebServer-ASG-Version-${aws_launch_template.web.latest_version}"
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = [
    aws_default_subnet.default_az1.id,
    aws_default_subnet.default_az2.id
  ]
  target_group_arns = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  dynamic "tag" {
    for_each = {
      "Name"  = "WebServer-ASG-v${aws_launch_template.web.latest_version}"
      "Owner" = "Kotlyar Maksim"
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
#-----------------------------------------------------------
# Load Balancer for Web Servers
resource "aws_lb" "web" {
   name = "WebServer-HighlyAvailable-ALB" 
   load_balancer_type = "application"
   security_groups = [aws_security_group.MyWebServerSG.id]
   subnets = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
}
resource "aws_lb_target_group" "web" {
    name = "WebServer-TargetGroup"
    port = 80
    protocol = "HTTP"
    deregistration_delay = 10
    vpc_id               = aws_default_vpc.default.id
}
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.web.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.web.arn
    }
  
}
#----------------------------------------------------------
# Outputs
output "web_alb_dns_name" {
  value       = aws_lb.web.dns_name
  description = "DNS name of the Web Server Load Balancer"
}
