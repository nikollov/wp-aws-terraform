#!/bin/bash
sudo echo "127.0.0.1 `hostname`" >> /etc/hosts

# Install prerequisint
#sudo yum update -y
sudo yum install mysql -y
sudo yum install epel-release -y
sudo yum install yum-utils -y 
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
sudo yum-config-manager --enable remi-php73 -y
sudo yum install php php-common php-opcache php-mcrypt php-cli php-gd php-curl php-mysqlnd -y
sudo yum install wget -y


#Disable Selinux
sudo setenforce 0
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config

#Install Apache
sudo yum install httpd -y
sudo systemctl enable httpd

#Install and configure WP
sudo wget -c http://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sleep 20
sudo mkdir -p /var/www/html/
sudo rsync -a wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
#sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo cp /tmp/wp-config.php /var/www/html/
sudo systemctl restart httpd
sleep 10
