# Alpine linux
FROM alpine:latest

ARG MYSQL_USER=root
ARG MYSQL_PASSWORD=phabricator
ARG MYSQL_PORT=3306
ARG MYSQL_HOST=phabricator-mariadb

# Install packages
RUN apk --update add \
    git \
    curl \
    nodejs \
    mysql-client \
    sudo \
    bash \
    openssh \
    pcre-dev \
    py-pygments \
    php5 \
    php5-pcntl \
    php5-pgsql \
    php5-posix \
    php5-opcache \
    php5-sqlite3 \
    php5-fpm \
    php5-gd \
    php5-dev \
    php5-pear \
    php5-apcu \
    php5-cli \
    php5-curl \
    php5-json \
    php5-pdo \
    php5-pdo_mysql \
    php5-iconv \
    php5-mysqli \
    php5-dom \
    php5-openssl \
    php5-mcrypt \
    php5-ctype \
    php5-phar \
    php5-xml \
    php5-zip


# Make /var/www a work dir
WORKDIR /var/www

# Clone phabricator
RUN git clone https://github.com/phacility/libphutil.git \
    && git clone https://github.com/phacility/arcanist.git \
    && git clone https://github.com/phacility/phabricator.git \
    && git clone https://github.com/PHPOffice/PHPExcel.git

RUN adduser -D -g "" -s /bin/sh vcs-user \
    && sed -i 's/vcs-user:!/vcs-user:NP/' /etc/shadow \
    && adduser -D -g "" -s /bin/sh daemon-user

# Create folders
RUN mkdir -p /var/storage \
    && mkdir -p /var/tmp/aphlict/pid \
    && mkdir -p /usr/local/sbin \
    && mkdir -p /var/repo \
    && chmod -R 777 /var/repo \
    && chmod -R 777 /var/storage \
    && chown daemon-user /var/tmp/aphlict/pid \
    && chown root /usr/lib/ \
    && chmod 755 /etc/sudoers \
    && chmod 777 /var/tmp/aphlict/pid

VOLUME /var/storage
VOLUME /var/repo

# Configure phabricator
RUN ./phabricator/bin/config set mysql.host $MYSQL_HOST \
  && ./phabricator/bin/config set mysql.port $MYSQL_PORT \
  && ./phabricator/bin/config set mysql.user $MYSQL_USER \
  && ./phabricator/bin/config set mysql.pass $MYSQL_PASSWORD \
  && ./phabricator/bin/config set phd.user root \
	&& ./phabricator/bin/config set diffusion.ssh-port 2222 \
  && ./phabricator/bin/config set diffusion.ssh-user vcs-user \
	&& ./phabricator/bin/config set policy.allow-public true \
	&& ./phabricator/bin/config set diffusion.allow-http-auth false \
	&& ./phabricator/bin/config set phabricator.show-prototypes true \
  && ./phabricator/bin/config set pygments.enabled true \
  && ./phabricator/bin/config set metamta.mail-adapter PhabricatorMailImplementationPHPMailerAdapter \
  && ./phabricator/bin/config set phpmailer.mailer smtp \
	&& ./phabricator/bin/config set storage.local-disk.path /var/storage

RUN cd /var/www/phabricator/support/aphlict/server/ && npm install ws

# Copy configuration
COPY ./php-fpm.conf /etc/php5/php-fpm.conf
COPY ./php.ini /etc/php5/conf.d/99-overwrites.ini
COPY ./sudoers /etc/sudoers
COPY ./phabricator-ssh-hook.sh /usr/lib/phabricator-ssh-hook.sh
COPY ./sshd_config.phabricator /etc/ssh/sshd_config.phabricator

RUN chown root /usr/lib/phabricator-ssh-hook.sh \
  && chmod 755 /usr/lib/phabricator-ssh-hook.sh

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
  && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
	&& ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa \
	&& ssh-keygen -A

# Expose sshd port
EXPOSE 2222

# Expose php-fpm port
EXPOSE 9000

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["start"]
