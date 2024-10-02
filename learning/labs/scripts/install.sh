#!/bin/bash
apt update
apt install -y apache2
mv /var/www/html/index.html /var/www/html/index.html.bak
echo "<html><body><h1>Hello, World!</h1></body></html>" > /var/www/html/index.html
systemctl restart apache2