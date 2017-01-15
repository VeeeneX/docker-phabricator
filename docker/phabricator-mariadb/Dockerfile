FROM mariadb:latest

COPY ./phabricator.cnf /etc/mysql/conf.d/phabricator.cnf

RUN chmod 644 /etc/mysql/conf.d/phabricator.cnf

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld"]
