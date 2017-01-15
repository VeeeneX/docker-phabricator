#!/bin/sh

while ! nc -z ${MYSQL_HOST} 3306;
do
    sleep 1;
done;

/var/www/phabricator/bin/phd start
/usr/sbin/sshd -f /etc/ssh/sshd_config.phabricator
su - daemon-user -c "/var/www/phabricator/bin/aphlict start"

if [ "${1}" = "start" ]; then
  exec bash -c "/usr/sbin/php-fpm -F -O 2>&1"
else
  exec $@
fi
