FROM debian:buster-slim

LABEL sh.demyx.image demyx/openlitespeed
LABEL sh.demyx.maintainer Demyx <info@demyx.sh>
LABEL sh.demyx.url https://demyx.sh
LABEL sh.demyx.github https://github.com/demyxco
LABEL sh.demyx.registry https://hub.docker.com/u/demyx

# Set default variables
ENV OPENLITESPEED_ROOT=/demyx
ENV OPENLITESPEED_CONFIG=/etc/demyx
ENV OPENLITESPEED_LOG=/var/log/demyx
ENV OPENLITESPEED_VERSION=1.6.4
ENV OPENLITESPEED_LSPHP_VERSION=lsphp73
ENV OPENLITESPEED_ADMIN=/demyx/ols
ENV OPENLITESPEED_ADMIN_PREFIX=true
ENV OPENLITESPEED_ADMIN_IP=ALL
ENV OPENLITESPEED_ADMIN_USERNAME=demyx
ENV OPENLITESPEED_ADMIN_PASSWORD=demyx
ENV OPENLITESPEED_BASIC_AUTH_USERNAME=demyx
ENV OPENLITESPEED_BASIC_AUTH_PASSWORD=demyx
ENV OPENLITESPEED_BASIC_AUTH_WP=false
ENV OPENLITESPEED_CACHE=false
ENV OPENLITESPEED_CLIENT_THROTTLE_STATIC=50
ENV OPENLITESPEED_CLIENT_THROTTLE_DYNAMIC=50
ENV OPENLITESPEED_CLIENT_THROTTLE_BANDWIDTH_OUT=0
ENV OPENLITESPEED_CLIENT_THROTTLE_BANDWIDTH_IN=0
ENV OPENLITESPEED_CLIENT_THROTTLE_SOFT_LIMIT=250
ENV OPENLITESPEED_CLIENT_THROTTLE_HARD_LIMIT=500
ENV OPENLITESPEED_CLIENT_THROTTLE_BLOCK_BAD_REQUEST=1
ENV OPENLITESPEED_CLIENT_THROTTLE_GRACE_PERIOD=15
ENV OPENLITESPEED_CLIENT_THROTTLE_BAN_PERIOD=60
ENV OPENLITESPEED_CRAWLER_LOAD_LIMIT=5.2
ENV OPENLITESPEED_CRAWLER_USLEEP=1000
ENV OPENLITESPEED_TUNING_MAX_CONNECTIONS=1000
ENV OPENLITESPEED_TUNING_CONNECTION_TIMEOUT=60
ENV OPENLITESPEED_TUNING_MAX_KEEP_ALIVE=500
ENV OPENLITESPEED_TUNING_SMART_KEEP_ALIVE=0
ENV OPENLITESPEED_TUNING_KEEP_ALIVE_TIMEOUT=5
ENV OPENLITESPEED_PHP_LSAPI_CHILDREN=1000
ENV OPENLITESPEED_PHP_OPCACHE=true
ENV OPENLITESPEED_PHP_MAX_EXECUTION_TIME=300
ENV OPENLITESPEED_PHP_MEMORY=256M
ENV OPENLITESPEED_PHP_UPLOAD_LIMIT=128M
ENV OPENLITESPEED_RECAPTCHA_ENABLE=1
ENV OPENLITESPEED_RECAPTCHA_TYPE=2
ENV OPENLITESPEED_RECAPTCHA_CONNECTION_LIMIT=100
ENV OPENLITESPEED_XMLRPC=false
ENV TZ America/Los_Angeles
ENV TERM=xterm

# Configure Demyx
RUN set -ex; \
    adduser --gecos '' --disabled-password demyx; \
    \
    install -d -m 0755 -o demyx -g demyx "$OPENLITESPEED_ROOT"; \
    install -d -m 0755 -o demyx -g demyx "$OPENLITESPEED_CONFIG"; \
    install -d -m 0755 -o demyx -g demyx "$OPENLITESPEED_LOG"

# OpenLiteSpeed
# Install these packages if you want to recompile PHP
# gcc libxml2-dev pkg-config libssl-dev zlib1g-dev libcurl4-gnutls-dev libpng-dev libzip-dev make
RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends ca-certificates dumb-init ed procps sudo tzdata wget; \
    \
    wget https://openlitespeed.org/packages/openlitespeed-"$OPENLITESPEED_VERSION".tgz -qO /tmp/openlitespeed-"$OPENLITESPEED_VERSION".tgz; \
    tar -xzf /tmp/openlitespeed-"$OPENLITESPEED_VERSION".tgz -C /tmp; \
    cd /tmp/openlitespeed && ./install.sh; \
    rm -rf /tmp/*; \
    \
    wget -O - https://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | bash; \
    \
    apt-get update && apt-get install -y \
        "$OPENLITESPEED_LSPHP_VERSION" \
        "$OPENLITESPEED_LSPHP_VERSION"-curl \
        "$OPENLITESPEED_LSPHP_VERSION"-imagick \
        "$OPENLITESPEED_LSPHP_VERSION"-json \
        "$OPENLITESPEED_LSPHP_VERSION"-mysql; \
    \
    ln -sf /usr/local/lsws/"$OPENLITESPEED_LSPHP_VERSION"/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp5

# WordPress
RUN set -ex; \
    wget https://wordpress.org/latest.tar.gz -qO "$OPENLITESPEED_CONFIG"/latest.tar.gz; \
    tar -xzf "$OPENLITESPEED_CONFIG"/latest.tar.gz -C "$OPENLITESPEED_CONFIG"; \
    rm "$OPENLITESPEED_CONFIG"/latest.tar.gz; \
    chown -R demyx:demyx "$OPENLITESPEED_CONFIG"/wordpress

# Copy files
COPY --chown=demyx:demyx demyx "$OPENLITESPEED_CONFIG"
COPY demyx.sh /usr/local/bin/demyx

# Setup sudo
RUN set -ex; \
    \
    # Sudo wrappers
    echo '#!/bin/bash' > /usr/local/bin/demyx-admin; \
    echo 'sudo "$OPENLITESPEED_CONFIG"/admin.sh' >> /usr/local/bin/demyx-admin; \
    chmod +x /usr/local/bin/demyx-admin; \
    chmod +x "$OPENLITESPEED_CONFIG"/admin.sh; \
    \
    echo '#!/bin/bash' > /usr/local/bin/demyx-config; \
    echo 'sudo "$OPENLITESPEED_CONFIG"/config.sh' >> /usr/local/bin/demyx-config; \
    chmod +x /usr/local/bin/demyx-config; \
    chmod +x "$OPENLITESPEED_CONFIG"/config.sh; \
    \
    echo '#!/bin/bash' > /usr/local/bin/demyx-htpasswd; \
    echo 'sudo "$OPENLITESPEED_CONFIG"/htpasswd.sh' >> /usr/local/bin/demyx-htpasswd; \
    chmod +x /usr/local/bin/demyx-htpasswd; \
    chmod +x "$OPENLITESPEED_CONFIG"/htpasswd.sh; \
    \
    echo '#!/bin/bash' > /usr/local/bin/demyx-lsws; \
    echo 'sudo "$OPENLITESPEED_CONFIG"/lsws.sh "$@"' >> /usr/local/bin/demyx-lsws; \
    chmod +x /usr/local/bin/demyx-lsws; \
    chmod +x "$OPENLITESPEED_CONFIG"/lsws.sh; \
    \
    mv "$OPENLITESPEED_CONFIG"/sudoers /etc/sudoers.d/demyx; \
    chown root:root /etc/sudoers.d/demyx

# Finalize
RUN set -ex;\ 
    # Create directory for lsadm user
    install -d -m 0755 -o lsadm -g lsadm "$OPENLITESPEED_CONFIG"/ols; \
    \
    # Symlink configs to lsws
    ln -sf "$OPENLITESPEED_CONFIG"/ols/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf; \
    ln -sf "$OPENLITESPEED_CONFIG"/ols/admin_config.conf /usr/local/lsws/admin/conf/admin_config.conf; \
    ln -s "$OPENLITESPEED_CONFIG"/ols /usr/local/lsws/conf/vhosts; \
    \
    # Make non-root scripts executable
    chmod +x "$OPENLITESPEED_CONFIG"/encrypt.sh; \
    chmod +x "$OPENLITESPEED_CONFIG"/install.sh; \
    chmod +x /usr/local/bin/demyx; \
    \
    mv "$OPENLITESPEED_CONFIG"/encrypt.sh /usr/local/bin/demyx-encrypt; \
    mv "$OPENLITESPEED_CONFIG"/install.sh /usr/local/bin/demyx-install; \
    \
    rm -f webadmin.csr privkey.pem

EXPOSE 80 8080

WORKDIR "$OPENLITESPEED_ROOT"

USER demyx

ENTRYPOINT ["dumb-init", "demyx"]
