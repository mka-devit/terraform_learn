#!/bin/bash
# This script is used to set up a web server on an AWS EC2 instance.
yum -y update
yum -y install httpd
myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform! Using external script" > /var/www/html/index.html
echo "<br><font color='red'>Hello World" >> /var/www/html/index.html
echo "<br><font color='blue'>123" >> /var/www/html/index.html
systemctl start httpd
systemctl enable httpd

