FROM mariadb:latest

# Maintainer
MAINTAINER VeeeneX <veeenex@gmail.com>

COPY docker/phabricator-mariadb/phabricator.cnf /etc/mysql/conf.d/phabricator.cnf

RUN chmod 644 /etc/mysql/conf.d/phabricator.cnf

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld"]
