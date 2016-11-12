#!/bin/sh


./phabricator/bin/phd start
su - daemon-user -c "/var/www/phabricator/bin/aphlict start"
/usr/sbin/sshd -f /etc/ssh/sshd_config.phabricator

php-fpm -F -O 2>&1
