FROM demyx/openlitespeed

LABEL sh.demyx.image            demyx/openlitespeed:bedrock
LABEL sh.demyx.maintainer       Demyx <info@demyx.sh>
LABEL sh.demyx.url              https://demyx.sh
LABEL sh.demyx.github           https://github.com/demyxsh
LABEL sh.demyx.registry         https://hub.docker.com/u/demyx

# Default bedrock to production
ENV DEMYX_BEDROCK               true
ENV DEMYX_BEDROCK_MODE          production
ENV DEMYX_SSL                   false
# Support for old variables
ENV WORDPRESS_BEDROCK_MODE      "$DEMYX_BEDROCK_MODE"

# Need root stuff
USER root

# Install packages
RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends git unzip

# Composer
RUN set -ex; \
    su -c "wget https://getcomposer.org/installer -qO /tmp/composer-setup.php" -s /bin/sh demyx; \
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Bedrock
RUN set -ex; \
    # Remove old files
    rm -f "$DEMYX_CONFIG"/wordpress.tgz; \
    rm -f /usr/local/bin/demyx-install; \
    rm -rf "$DEMYX"/*; \
    \
    # Configure Bedrock
    su -c "composer create-project roots/bedrock /tmp/bedrock; \
        \
        sed -i 's|\"roots/wordpress\": .*|\"roots/wordpress\": \">1\",|g' /tmp/bedrock/composer.json; \
        \
        cd /tmp/bedrock && composer require roots/acorn; \
        \
        cp -r /tmp/bedrock/. ${DEMYX}; \
        \
        tar -czf ${DEMYX_CONFIG}/bedrock.tgz -C /tmp/bedrock ." -s /bin/sh demyx

# Imports
COPY bin /usr/local/bin

# Finalize
RUN set -ex;\
    # Set ownership
    chown -R root:root /usr/local/bin; \
    \
    # Clear /tmp
    rm -rf /tmp/*

USER demyx
