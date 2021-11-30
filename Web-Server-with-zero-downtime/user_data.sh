#!/bin/bash
apt -y update
apt -y install apache2
ip=`curl wgetip.com`
cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="black">
<h2><font color="green">Hello from Terraform</h2><br><p>
<font color="green">Server IP: <font color="yelow">$ip<br><br>
</body>
</html>
EOF
systemctl restart apache2
