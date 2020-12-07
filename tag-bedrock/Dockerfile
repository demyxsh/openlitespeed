FROM demyx/openlitespeed

LABEL sh.demyx.image            demyx/openlitespeed:bedrock
LABEL sh.demyx.maintainer       Demyx <info@demyx.sh>
LABEL sh.demyx.url              https://demyx.sh
LABEL sh.demyx.github           https://github.com/demyxco
LABEL sh.demyx.registry         https://hub.docker.com/u/demyx

# Default bedrock to production
ENV DEMYX_BEDROCK               true
ENV DEMYX_BEDROCK_MODE          production
ENV DEMYX_SSL                   false
# Support for old variables
ENV WORDPRESS_BEDROCK_MODE      "$DEMYX_BEDROCK_MODE"

# Need root stuff
USER root

# php 7.4 and friends
RUN set -ex; \
    /usr/bin/apt-get install -y --no-install-recommends lsb-release apt-transport-https; \
    /usr/bin/wget https://packages.sury.org/php/apt.gpg -qO /etc/apt/trusted.gpg.d/php.gpg; \
    /bin/echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | /usr/bin/tee /etc/apt/sources.list.d/php.list; \
    /usr/bin/apt-get update && /usr/bin/apt-get install -y --no-install-recommends git php7.4 php7.4-zip php7.4-xml unzip

# Composer
RUN set -ex; \
    su -c "/usr/bin/wget https://getcomposer.org/installer -qO /tmp/composer-setup.php" -s /bin/sh demyx; \
    /usr/bin/php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Bedrock
RUN set -ex; \
    # Remove WordPress
    /bin/rm -rf "$DEMYX_CONFIG"/wordpress.tgz; \
    /bin/rm -rf "$DEMYX"/*; \
    \
    /bin/su -c "/usr/local/bin/composer create-project roots/bedrock /tmp/bedrock" -s /bin/sh demyx; \
    \
    # Upgrade WordPress to latest version
    /bin/sed -i 's|"roots/wordpress": .*|"roots/wordpress": ">5",|g' /tmp/bedrock/composer.json; \
    \
    /bin/su -c "cd /tmp/bedrock && /usr/local/bin/composer update; \
        \
        /usr/local/bin/composer clearcache; \
        \
        /bin/rm -f /tmp/composer-setup.php; \
        \
        /bin/cp -r . ${DEMYX}; \
        \
        /bin/tar -czf ${DEMYX_CONFIG}/bedrock.tgz -C /tmp/bedrock ." -s /bin/sh demyx

# Copy source
COPY --chown=demyx:demyx src "$DEMYX_CONFIG"

# Finalize
RUN set -ex; \
    /bin/chmod +x "$DEMYX_CONFIG"/config.sh; \
    /bin/chmod +x "$DEMYX_CONFIG"/install.sh; \
    \
    # demyx-install
    /bin/cp "$DEMYX_CONFIG"/install.sh /usr/local/bin/demyx-install; \
    /bin/chmod +x /usr/local/bin/demyx-install; \
    \
    # Clear /tmp
    /bin/rm -rf /tmp/*

USER demyx
