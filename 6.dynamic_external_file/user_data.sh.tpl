#!/bin/bash

yum -y update
yum -y install httpd

myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /var/www/html/index.html
<html>
  <h2>Build by Power of Terraform, My local IP is: $myip <font color="red">v0.12</font></h2><br>
  Owner: ${f_name} ${s_name} <br>
  IP: $myip <br>
  <br>
%{ for x in name ~}
Hello to ${x} from ${f_name} <br>
%{ endfor ~}
</html>
EOF

sudo service httpd start
sudo chkconfig httpd on
