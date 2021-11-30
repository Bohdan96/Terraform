#!/bin/bash
apt -y update
apt -y install nginx
cat <<EOF > /usr/share/nginx/html/index.html
<html>
<h2>Build by Power of Terraform <font color="red"> v0.12</font></h2><br>
Owner ${f_name} <br>
%{ for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}
<p>
Server IP: $myip<br>
</html>
EOF
systemctl restart nginx
