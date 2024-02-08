FROM php:8.1-cli-bullseye

LABEL sh.demyx.image                            demyx/openlitespeed
LABEL sh.demyx.maintainer                       Demyx <info@demyx.sh>
LABEL sh.demyx.url                              https://demyx.sh
LABEL sh.demyx.github                           https://github.com/demyxsh
LABEL sh.demyx.registry                         https://hub.docker.com/u/demyx

# Set default variables
ENV DEMYX                                       /demyx
ENV DEMYX_BEDROCK                               false
ENV DEMYX_ADMIN                                 /demyx/ols
ENV DEMYX_ADMIN_IP                              ALL
ENV DEMYX_ADMIN_PASSWORD                        demyx
ENV DEMYX_ADMIN_PREFIX                          true
ENV DEMYX_ADMIN_USERNAME                        demyx
ENV DEMYX_BASIC_AUTH_PASSWORD                   demyx
ENV DEMYX_BASIC_AUTH_USERNAME                   demyx
ENV DEMYX_BASIC_AUTH_WP                         false
ENV DEMYX_CACHE                                 false
ENV DEMYX_CLIENT_THROTTLE_BANDWIDTH_IN          0
ENV DEMYX_CLIENT_THROTTLE_BANDWIDTH_OUT         0
ENV DEMYX_CLIENT_THROTTLE_BAN_PERIOD            60
ENV DEMYX_CLIENT_THROTTLE_BLOCK_BAD_REQUEST     1
ENV DEMYX_CLIENT_THROTTLE_DYNAMIC               1000
ENV DEMYX_CLIENT_THROTTLE_GRACE_PERIOD          30
ENV DEMYX_CLIENT_THROTTLE_HARD_LIMIT            2000
ENV DEMYX_CLIENT_THROTTLE_SOFT_LIMIT            1500
ENV DEMYX_CLIENT_THROTTLE_STATIC                1000
ENV DEMYX_CONFIG                                /etc/demyx
ENV DEMYX_CRAWLER_LOAD_LIMIT                    5.2
ENV DEMYX_CRAWLER_USLEEP                        1000
ENV DEMYX_CRON                                  true
ENV DEMYX_CRON_LOGROTATE_INTERVAL               "0 0 * * *"
ENV DEMYX_CRON_WP_INTERVAL                      "*/5 * * * *"
ENV DEMYX_DB_HOST                               localhost
ENV DEMYX_DB_NAME                               demyx
ENV DEMYX_DB_PASSWORD                           demyx
ENV DEMYX_DB_USERNAME                           demyx
ENV DEMYX_DOMAIN                                localhost
ENV DEMYX_LOG                                   /var/log/demyx
ENV DEMYX_LOGROTATE                             daily
ENV DEMYX_LOGROTATE_INTERVAL                    7
ENV DEMYX_LOGROTATE_SIZE                        10M
ENV DEMYX_LSAPI_AVOID_FORK                      0
ENV DEMYX_LSAPI_CHILDREN                        35
ENV DEMYX_LSAPI_MAX_IDLE                        300
ENV DEMYX_LSAPI_MAX_PROCESS_TIME                3600
ENV DEMYX_LSAPI_MAX_REQS                        10000
ENV DEMYX_MAX_EXECUTION_TIME                    300
ENV DEMYX_MEMORY                                256M
ENV DEMYX_OPCACHE                               true
ENV DEMYX_PROTO                                 http
ENV DEMYX_RECAPTCHA_CONNECTION_LIMIT            500
ENV DEMYX_RECAPTCHA_ENABLE                      1
ENV DEMYX_RECAPTCHA_TYPE                        2
ENV DEMYX_TUNING_CONNECTION_TIMEOUT             300
ENV DEMYX_TUNING_KEEP_ALIVE_TIMEOUT             300
ENV DEMYX_TUNING_MAX_CONNECTIONS                20000
ENV DEMYX_TUNING_MAX_KEEP_ALIVE                 1000
ENV DEMYX_TUNING_SMART_KEEP_ALIVE               1000
ENV DEMYX_UPLOAD_LIMIT                          128M
ENV DEMYX_WP_CONFIG                             "${DEMYX}/wp-config.php"
ENV DEMYX_WP_EMAIL                              info@domain.tld
ENV DEMYX_WP_PASSWORD                           demyx
ENV DEMYX_WP_USERNAME                           demyx
ENV DEMYX_XMLRPC                                false
ENV PATH                                        "${PATH}:/usr/local/lsws/${DEMYX_LSPHP}/bin"
ENV TZ                                          America/Los_Angeles
# Support for old variables
ENV OPENLITESPEED_ROOT                          /demyx
ENV OPENLITESPEED_CONFIG                        /etc/demyx
ENV OPENLITESPEED_LOG                           /var/log/demyx

# Packages
# Install these packages if you want to recompile PHP
# gcc libxml2-dev pkg-config libssl-dev zlib1g-dev libcurl4-gnutls-dev libpng-dev libzip-dev make
RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends \
        bc \
        ca-certificates \
        curl \
        default-mysql-client \
        ed \
        jq \
        libzip-dev \
        logrotate \
        mariadb-client \
        nano \
        procps \
        ruby \
        sudo \
        tzdata \
        wget; \
        \
        docker-php-ext-install mysqli pdo_mysql zip; \
        \
        apt-get purge -y libzip-dev

# Configure Demyx
RUN set -ex; \
    # Create demyx user
    adduser --gecos '' --disabled-password demyx; \
    \
    # Create demyx directories
    install -d -m 0755 -o demyx -g demyx "$DEMYX"; \
    install -d -m 0755 -o demyx -g demyx "$DEMYX_CONFIG"; \
    install -d -m 0755 -o demyx -g demyx "$DEMYX_LOG"; \
    \
    # Update .bashrc
    echo 'PS1="$(whoami)@\h:\w \$ "' > /home/demyx/.bashrc; \
    echo 'PS1="$(whoami)@\h:\w \$ "' > /root/.bashrc

# OpenLiteSpeed
RUN set -ex; \
    apt-get install -y --no-install-recommends curl; \
    \
    DEMYX_OLS_VERSION="$(wget -qO- https://api.github.com/repos/litespeedtech/openlitespeed/tags 2>&1 | jq -r '.[].name' | head -n 1 | sed 's|v||g' || true)"; \
    DEMYX_OLS_VERSION_CHECK="$(curl -s -o /dev/null -w "%{http_code}" https://openlitespeed.org/packages/openlitespeed-"$DEMYX_OLS_VERSION".tgz)"; \
    if [ "$DEMYX_OLS_VERSION_CHECK" = 404 ]; then DEMYX_OLS_VERSION=1.7.17; fi; \
    curl -sL https://openlitespeed.org/packages/openlitespeed-"$DEMYX_OLS_VERSION".tgz -o /tmp/openlitespeed-"$DEMYX_OLS_VERSION".tgz; \
    tar -xzf /tmp/openlitespeed-"$DEMYX_OLS_VERSION".tgz -C /tmp; \
    cd /tmp/openlitespeed && ./install.sh; \
    \
    wget -O - https://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | bash; \
    \
    apt-get update && apt-get install -y \
        "$DEMYX_LSPHP" \
        "$DEMYX_LSPHP"-curl \
        "$DEMYX_LSPHP"-imagick \
        "$DEMYX_LSPHP"-intl \
        "$DEMYX_LSPHP"-mysql \
        "$DEMYX_LSPHP"-redis \
        \
        lsphp81 \
        lsphp81-curl \
        lsphp81-imagick \
        lsphp81-intl \
        lsphp81-mysql \
        lsphp81-redis; \
    \
    ln -sf /usr/local/lsws/"$DEMYX_LSPHP"/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp5; \
    \
    # Create directory for lsadm user
    install -d -m 0755 -o lsadm -g lsadm "$DEMYX_CONFIG"/ols; \
    \
    # Symlink configs to lsws
    ln -sf "$DEMYX_CONFIG"/ols/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf; \
    ln -sf "$DEMYX_CONFIG"/ols/admin_config.conf /usr/local/lsws/admin/conf/admin_config.conf; \
    ln -s "$DEMYX_CONFIG"/ols /usr/local/lsws/conf/vhosts; \
    \
    # Remove curl and friends
    apt-get purge curl -y

# WordPress
RUN set -ex; \
    su -c "wget https://wordpress.org/latest.tar.gz -qO /tmp/latest.tar.gz; \
    \
    tar -xzf /tmp/latest.tar.gz -C /tmp; \
    \
    mv /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php; \
    \
    cp -r /tmp/wordpress/* ${DEMYX}; \
    \
    tar -czf ${DEMYX_CONFIG}/wordpress.tgz -C /tmp/wordpress ." -s /bin/sh demyx; \
    \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -qO /usr/local/bin/wp; \
    chmod +x /usr/local/bin/wp; \
    \
    su -c "wp package install aaemnnosttv/wp-cli-login-command; \
        wget https://raw.githubusercontent.com/aaemnnosttv/wp-cli-login-command/master/plugin/wp-cli-login-server.php -qO ${DEMYX_CONFIG}/wp-cli-login-server.php" -s /bin/sh demyx

# Imports
COPY bin /usr/local/bin

# Finalize
RUN set -ex; \
    # sudoers
    echo "demyx ALL=(ALL) NOPASSWD:SETENV: /usr/local/lsws/bin/lswsctrl, /usr/local/bin/demyx-admin, /usr/local/bin/demyx-config, /usr/local/bin/demyx-htpasswd, /usr/local/bin/demyx-lsws, /usr/local/bin/demyx-sudo" > /etc/sudoers.d/demyx; \
    # Set ownership
    chown -R root:root /usr/local/bin; \
    \
    # Clear /tmp
    rm -rf /tmp/*

EXPOSE 80 8080

WORKDIR "$DEMYX"

USER demyx

ENTRYPOINT ["demyx-entrypoint"]
