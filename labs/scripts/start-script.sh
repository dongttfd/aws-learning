#!/bin/bash
apt update
apt install -y apache2
cd /var/www/html
mv index.html index.html.bak

echo '<html>' >> index.html
echo '<body>' >> index.html
echo '<h1 style="color: blue;">Welcome Server B</h1>' >> index.html
echo '<h4 style="color: red;">You are run instance from this IP (for debug only!!! Do not public this to User)</h4>' >> index.html
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
echo '<br />Private IP:' >> index.html
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4 >> index.html
echo '<br />Public IP:' >> index.html
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html
echo '</body>' >> index.html
echo '</html>' >> index.html

systemctl restart apache2