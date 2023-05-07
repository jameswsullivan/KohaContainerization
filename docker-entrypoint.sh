#!/bin/bash
current_hostname=$(hostname)

service mysql start
service apache2 start
service memcached start
koha-create --create-db koha
service apache2 restart
a2enmod deflate
a2ensite koha
service apache2 restart

koha_password=$(grep "<pass>" /etc/koha/sites/koha/koha-conf.xml | awk -F'[<>]' '{print $3}')

sed -i 's/^bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "s|<hostname>localhost</hostname>|<hostname>${current_hostname}</hostname>|" /etc/koha/sites/koha/koha-conf.xml

mysql -e "
DROP USER 'koha_koha'@'localhost';
CREATE USER 'koha_koha'@'%' IDENTIFIED WITH mysql_native_password BY '$koha_password';
GRANT ALL PRIVILEGES ON koha_koha.* TO 'koha_koha'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;"

service koha-common restart
service mysql restart
service apache2 restart

echo -e "\n\nKoha Password: $koha_password"

exec "$@"
tail -f /dev/null