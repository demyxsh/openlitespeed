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
    apt-get install -y --no-install-recommends lsb-release apt-transport-https; \
    wget https://packages.sury.org/php/apt.gpg -qO /etc/apt/trusted.gpg.d/php.gpg; \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list; \
    apt-get update && apt-get install -y --no-install-recommends git php7.4 php7.4-zip php7.4-xml unzip

# Composer
RUN set -ex; \
    su -c "wget https://getcomposer.org/installer -qO /tmp/composer-setup.php" -s /bin/sh demyx; \
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Bedrock
RUN set -ex; \
    # Remove WordPress
    rm -rf "$DEMYX_CONFIG"/wordpress.tgz; \
    rm -rf "$DEMYX"/*; \
    \
    su -c "composer create-project roots/bedrock /tmp/bedrock" -s /bin/sh demyx; \
    \
    # Upgrade WordPress to latest version
    sed -i 's|"roots/wordpress": .*|"roots/wordpress": ">5",|g' /tmp/bedrock/composer.json; \
    \
    su -c "cd /tmp/bedrock && composer update; \
        \
        composer clearcache; \
        \
        rm -f /tmp/composer-setup.php; \
        \
        cp -r . ${DEMYX}; \
        \
        tar -czf ${DEMYX_CONFIG}/bedrock.tgz -C /tmp/bedrock ." -s /bin/sh demyx

# Imports
COPY --chown=root:root bin /usr/local/bin

# Finalize
RUN set -ex;\
    # Set ownership
    chown -R root:root /usr/local/bin; \
    \
    # Clear /tmp
    rm -rf /tmp/*

USER demyx
