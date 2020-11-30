FROM debian:buster-slim

LABEL sh.demyx.image                            demyx/openlitespeed
LABEL sh.demyx.maintainer                       Demyx <info@demyx.sh>
LABEL sh.demyx.url                              https://demyx.sh
LABEL sh.demyx.github                           https://github.com/demyxco
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
ENV DEMYX_WP_CONFIG                             "$DEMYX"/wp-config.php
ENV DEMYX_XMLRPC                                false
ENV TZ                                          America/Los_Angeles
# Support for old variables
ENV OPENLITESPEED_ROOT                          /demyx
ENV OPENLITESPEED_CONFIG                        /etc/demyx
ENV OPENLITESPEED_LOG                           /var/log/demyx

# Configure Demyx
RUN set -ex; \
    # Create demyx user
    /usr/sbin/adduser --gecos '' --disabled-password demyx; \
    \
    # Create demyx directories
    /usr/bin/install -d -m 0755 -o demyx -g demyx "$DEMYX"; \
    /usr/bin/install -d -m 0755 -o demyx -g demyx "$DEMYX_CONFIG"; \
    /usr/bin/install -d -m 0755 -o demyx -g demyx "$DEMYX_LOG"

# OpenLiteSpeed
# Install these packages if you want to recompile PHP
# gcc libxml2-dev pkg-config libssl-dev zlib1g-dev libcurl4-gnutls-dev libpng-dev libzip-dev make
RUN set -ex; \
    /usr/bin/apt-get update && /usr/bin/apt-get install -y --no-install-recommends \
        ca-certificates \
        ed \
        jq \
        procps \
        ruby \
        sudo \
        tzdata \
        wget; \
    \
    DEMYX_VERSION="$(/usr/bin/wget -qO- https://api.github.com/repos/litespeedtech/openlitespeed/tags 2>&1 | /usr/bin/jq -r '.[].name' | /usr/bin/head -n 1 | /bin/sed 's|v||g')"; \
    /usr/bin/wget https://openlitespeed.org/packages/openlitespeed-"$DEMYX_VERSION".tgz -qO /tmp/openlitespeed-"$DEMYX_VERSION".tgz; \
    /bin/tar -xzf /tmp/openlitespeed-"$DEMYX_VERSION".tgz -C /tmp; \
    cd /tmp/openlitespeed && ./install.sh; \
    \
    /usr/bin/wget -O - https://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | /bin/bash; \
    \
    /usr/bin/apt-get update && /usr/bin/apt-get install -y \
        "$DEMYX_LSPHP_VERSION" \
        "$DEMYX_LSPHP_VERSION"-curl \
        "$DEMYX_LSPHP_VERSION"-imagick \
        "$DEMYX_LSPHP_VERSION"-json \
        "$DEMYX_LSPHP_VERSION"-mysql; \
    \
    /bin/ln -sf /usr/local/lsws/"$DEMYX_LSPHP_VERSION"/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp5; \
    \
    # Create directory for lsadm user
    /usr/bin/install -d -m 0755 -o lsadm -g lsadm "$DEMYX_CONFIG"/ols; \
    \
    # Symlink configs to lsws
    /bin/ln -sf "$DEMYX_CONFIG"/ols/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf; \
    /bin/ln -sf "$DEMYX_CONFIG"/ols/admin_config.conf /usr/local/lsws/admin/conf/admin_config.conf; \
    /bin/ln -s "$DEMYX_CONFIG"/ols /usr/local/lsws/conf/vhosts; \
    \
    /bin/rm -rf /tmp/*

# WordPress
RUN set -ex; \
    /usr/bin/wget https://wordpress.org/latest.tar.gz -qO "$DEMYX_CONFIG"/latest.tar.gz; \
    /bin/tar -xzf "$DEMYX_CONFIG"/latest.tar.gz -C "$DEMYX_CONFIG"; \
    /bin/cp -r "$DEMYX_CONFIG"/wordpress/* "$DEMYX"; \
    /bin/rm "$DEMYX_CONFIG"/latest.tar.gz; \
    /bin/chown -R demyx:demyx "$DEMYX_CONFIG"/wordpress; \
    /bin/chown -R demyx:demyx "$DEMYX"

# Imports
COPY --chown=demyx:demyx src "$DEMYX_CONFIG"

# Configure sudo
RUN set -ex; \
    # sudoers
    /bin/echo "demyx ALL=(ALL) NOPASSWD:SETENV: /usr/local/lsws/bin/lswsctrl, /etc/demyx/admin.sh, /etc/demyx/config.sh, /etc/demyx/htpasswd.sh, /etc/demyx/lsws.sh" > /etc/sudoers.d/demyx; \
    \
    # demyx-admin
    /bin/echo '#!/bin/bash' > /usr/local/bin/demyx-admin; \
    /bin/echo '/usr/bin/sudo -E "$DEMYX_CONFIG"/admin.sh' >> /usr/local/bin/demyx-admin; \
    /bin/chmod +x /usr/local/bin/demyx-admin; \
    /bin/chmod +x "$DEMYX_CONFIG"/admin.sh; \
    \
    # demyx-config
    /bin/echo '#!/bin/bash' > /usr/local/bin/demyx-config; \
    /bin/echo '/usr/bin/sudo -E "$DEMYX_CONFIG"/config.sh' >> /usr/local/bin/demyx-config; \
    /bin/chmod +x /usr/local/bin/demyx-config; \
    /bin/chmod +x "$DEMYX_CONFIG"/config.sh; \
    \
    # demyx-htpasswd
    /bin/echo '#!/bin/bash' > /usr/local/bin/demyx-htpasswd; \
    /bin/echo '/usr/bin/sudo -E "$DEMYX_CONFIG"/htpasswd.sh' >> /usr/local/bin/demyx-htpasswd; \
    /bin/chmod +x /usr/local/bin/demyx-htpasswd; \
    /bin/chmod +x "$DEMYX_CONFIG"/htpasswd.sh; \
    \
    # demyx-lsws
    /bin/echo '#!/bin/bash' > /usr/local/bin/demyx-lsws; \
    /bin/echo '/usr/bin/sudo -E "$DEMYX_CONFIG"/lsws.sh "$@"' >> /usr/local/bin/demyx-lsws; \
    /bin/chmod +x /usr/local/bin/demyx-lsws; \
    /bin/chmod +x "$DEMYX_CONFIG"/lsws.sh

# Finalize
RUN set -ex;\ 
    # demyx-encrypt
    /bin/cp "$DEMYX_CONFIG"/encrypt.sh /usr/local/bin/demyx-encrypt; \
    /bin/chmod +x /usr/local/bin/demyx-encrypt; \
    \
    # demyx-install
    /bin/cp "$DEMYX_CONFIG"/install.sh /usr/local/bin/demyx-install; \
    /bin/chmod +x /usr/local/bin/demyx-install; \
    \
    # demyx-entrypoint
    /bin/cp "$DEMYX_CONFIG"/entrypoint.sh /usr/local/bin/demyx-entrypoint; \
    /bin/chmod +x /usr/local/bin/demyx-entrypoint; \
    \
    # Reset permissions
    /bin/chown -R root:root /usr/local/bin; \
    \
    # Remove unused files
    /bin/rm -f webadmin.csr privkey.pem

EXPOSE 80 8080

WORKDIR "$DEMYX"

USER demyx

ENTRYPOINT ["/usr/local/bin/demyx-entrypoint"]
