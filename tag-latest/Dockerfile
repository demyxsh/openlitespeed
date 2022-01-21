FROM debian:buster-slim

LABEL sh.demyx.image                            demyx/openlitespeed
LABEL sh.demyx.maintainer                       Demyx <info@demyx.sh>
LABEL sh.demyx.url                              https://demyx.sh
LABEL sh.demyx.github                           https://github.com/demyxsh
LABEL sh.demyx.registry                         https://hub.docker.com/u/demyx

# Set default variables
ENV DEMYX                                       /demyx
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
ENV DEMYX_DB_HOST                               localhost
ENV DEMYX_DB_NAME                               demyx
ENV DEMYX_DB_PASSWORD                           demyx
ENV DEMYX_DB_USER                               demyx
ENV DEMYX_DOMAIN                                localhost
ENV DEMYX_LOG                                   /var/log/demyx
ENV DEMYX_LSPHP_VERSION                         lsphp74
ENV DEMYX_PHP_LSAPI_CHILDREN                    2000
ENV DEMYX_PHP_MAX_EXECUTION_TIME                300
ENV DEMYX_PHP_MEMORY                            256M
ENV DEMYX_PHP_OPCACHE                           true
ENV DEMYX_PHP_UPLOAD_LIMIT                      128M
ENV DEMYX_RECAPTCHA_CONNECTION_LIMIT            500
ENV DEMYX_RECAPTCHA_ENABLE                      1
ENV DEMYX_RECAPTCHA_TYPE                        2
ENV DEMYX_TUNING_CONNECTION_TIMEOUT             300
ENV DEMYX_TUNING_KEEP_ALIVE_TIMEOUT             300
ENV DEMYX_TUNING_MAX_CONNECTIONS                20000
ENV DEMYX_TUNING_MAX_KEEP_ALIVE                 1000
ENV DEMYX_TUNING_SMART_KEEP_ALIVE               1000
ENV DEMYX_WP_CONFIG                             "${DEMYX}/wp-config.php"
ENV DEMYX_XMLRPC                                false
ENV PATH                                        "${PATH}:/usr/local/lsws/${DEMYX_LSPHP_VERSION}/bin"
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
        ca-certificates \
        ed \
        jq \
        procps \
        ruby \
        sudo \
        tzdata \
        wget

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
    DEMYX_OLS_VERSION="$(wget -qO- https://api.github.com/repos/litespeedtech/openlitespeed/tags 2>&1 | jq -r '.[].name' | head -n 1 | sed 's|v||g' || true)"; \
    wget https://openlitespeed.org/packages/openlitespeed-"$DEMYX_OLS_VERSION".tgz -qO /tmp/openlitespeed-"$DEMYX_OLS_VERSION".tgz; \
    tar -xzf /tmp/openlitespeed-"$DEMYX_OLS_VERSION".tgz -C /tmp; \
    cd /tmp/openlitespeed && ./install.sh; \
    \
    wget -O - https://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | bash; \
    \
    apt-get update && apt-get install -y \
        "$DEMYX_LSPHP_VERSION" \
        "$DEMYX_LSPHP_VERSION"-curl \
        "$DEMYX_LSPHP_VERSION"-imagick \
        "$DEMYX_LSPHP_VERSION"-json \
        "$DEMYX_LSPHP_VERSION"-mysql; \
    \
    ln -sf /usr/local/lsws/"$DEMYX_LSPHP_VERSION"/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp5; \
    \
    # Create directory for lsadm user
    install -d -m 0755 -o lsadm -g lsadm "$DEMYX_CONFIG"/ols; \
    \
    # Symlink configs to lsws
    ln -sf "$DEMYX_CONFIG"/ols/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf; \
    ln -sf "$DEMYX_CONFIG"/ols/admin_config.conf /usr/local/lsws/admin/conf/admin_config.conf; \
    ln -s "$DEMYX_CONFIG"/ols /usr/local/lsws/conf/vhosts

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
        tar -czf ${DEMYX_CONFIG}/wordpress.tgz -C /tmp/wordpress ." -s /bin/sh demyx

# Imports
COPY --chown=root:root bin /usr/local/bin

# Configure sudo
RUN set -ex; \
    # sudoers
    echo "demyx ALL=(ALL) NOPASSWD:SETENV: /usr/local/lsws/bin/lswsctrl, /usr/local/bin/demyx-admin, /usr/local/bin/demyx-config, /usr/local/bin/demyx-htpasswd, /usr/local/bin/demyx-lsws" > /etc/sudoers.d/demyx

# Finalize
RUN set -ex;\
    # Set ownership
    chown -R root:root /usr/local/bin; \
    \
    # Clear /tmp
    rm -rf /tmp/*

EXPOSE 80 8080

WORKDIR "$DEMYX"

USER demyx

ENTRYPOINT ["demyx-entrypoint"]
