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
    /usr/bin/wget https://getcomposer.org/installer -qO /tmp/composer-setup.php; \
    /usr/bin/php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    /bin/rm -rf /tmp/*

# Bedrock
RUN set -ex; \
    # Remove WordPress
    /bin/rm -rf "$DEMYX_CONFIG"/wordpress; \
    /bin/rm -rf "$DEMYX"/*; \
    \
    /bin/su -c "/usr/local/bin/composer create-project roots/bedrock ${DEMYX_CONFIG}/bedrock" -s /bin/sh demyx; \
    \
    # Upgrade WordPress to latest version
    /bin/sed -i 's|"roots/wordpress": .*|"roots/wordpress": ">5",|g' "$DEMYX_CONFIG"/bedrock/composer.json; \
    \
    /bin/su -c "cd ${DEMYX_CONFIG}/bedrock && /usr/local/bin/composer update; \
    \
    /usr/local/bin/composer clearcache" -s /bin/sh demyx; \
    \
    /bin/cp -r "$DEMYX_CONFIG"/bedrock/. "$DEMYX"; \
    /bin/chown -R demyx:demyx "$DEMYX"

# Copy source
COPY --chown=demyx:demyx src "$DEMYX_CONFIG"

# Finalize
RUN set -ex; \
    /bin/chmod +x "$DEMYX_CONFIG"/config.sh; \
    /bin/chmod +x "$DEMYX_CONFIG"/install.sh; \
    \
    # demyx-install
    /bin/cp "$DEMYX_CONFIG"/install.sh /usr/local/bin/demyx-install; \
    /bin/chmod +x /usr/local/bin/demyx-install

USER demyx
