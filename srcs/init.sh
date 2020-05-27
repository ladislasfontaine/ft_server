#! /bin/bash

#SSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=lafontai' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

#NGINX
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost

#PHPMYADMIN
mkdir /var/www/html/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -xvzf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/html/phpmyadmin
rm -rf phpMyAdmin-4.9.0.1-all-languages.tar.gz
mv ./config.inc.php /var/www/html/phpmyadmin

#WORDPRESS
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
rm -rf latest.tar.gz
chmod 755 -R wordpress
mv wordpress/ /var/www/html
mv ./wp-config.php /var/www/html/wordpress

#CHMOD
chmod 755 -R ./var/www/html
chown -R www-data:www-data /var/www/html/*

#MYSQL
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

#manage autoindex
if [ $AUTO_INDEX = off ]
then
	sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-enabled/localhost
fi

#start services
service php7.3-fpm start
service nginx start

/bin/bash