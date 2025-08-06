#!/bin/bash
# This script sets up a web server on an AWS EC2 instance using ifconfig to get IP.

yum -y update
yum -y install httpd net-tools  # 'net-tools' нужен для команды 'ifconfig'

# Получаем IP-адрес с помощью ifconfig (предположим, что используется интерфейс eth0)
myip=$(ifconfig eth0 | grep 'inet ' | awk '{print $2}')

# Создаём HTML-страницу
echo "<h2>WebServer with IPs: $myip</h2><br>Build by Terraform! Using ifconfig" > /var/www/html/index.html
echo "<br><font color='red'>Hello World" >> /var/www/html/index.html
echo "<br><font color='blue'>0123456789" >> /var/www/html/index.html

# Запуск и автозапуск Apache
systemctl start httpd
systemctl enable httpd
