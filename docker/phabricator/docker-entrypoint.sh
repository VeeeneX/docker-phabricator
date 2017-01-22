#!/bin/sh

while ! nc -z ${MYSQL_HOST} 3306;
do
    sleep 1;
done;

/var/www/phabricator/bin/phd start
/var/www/phabricator/bin/aphlict start

# Start SSH
/usr/sbin/sshd -f /etc/ssh/sshd_config.phabricator

if [ "${1}" = "start" ]; then
  exec bash -c "/usr/bin/php-fpm -F -O 2>&1"
else
  exec $@
fi
