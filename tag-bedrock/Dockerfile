FROM demyx/openlitespeed

LABEL sh.demyx.image        demyx/openlitespeed:bedrock
LABEL sh.demyx.maintainer   Demyx <info@demyx.sh>
LABEL sh.demyx.url          https://demyx.sh
LABEL sh.demyx.github       https://github.com/demyxco
LABEL sh.demyx.registry     https://hub.docker.com/u/demyx

# Default bedrock to production
ENV WORDPRESS_BEDROCK_MODE  production

# Need root stuff
USER root

# php 7.4 and friends
RUN set -ex; \
    apt-get install -y --no-install-recommends lsb-release apt-transport-https wget; \
    wget https://packages.sury.org/php/apt.gpg -qO /etc/apt/trusted.gpg.d/php.gpg; \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list; \
    apt-get update && apt-get install -y --no-install-recommends git php7.4 php7.4-zip php7.4-xml unzip

# Composer
RUN set -ex; \
    wget https://getcomposer.org/installer -qO /tmp/composer-setup.php; \
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    rm -rf /tmp/*

# Bedrock
RUN set -ex; \
    # Remove WordPress
    rm -rf "$OPENLITESPEED_CONFIG"/wordpress; \
    rm -rf "$OPENLITESPEED_ROOT"/*; \
    \
    su -c "composer create-project roots/bedrock ${OPENLITESPEED_CONFIG}/bedrock" -s /bin/sh demyx; \
    \
    # Upgrade WordPress to latest version
    sed -i 's|"roots/wordpress": .*|"roots/wordpress": ">5",|g' "$OPENLITESPEED_CONFIG"/bedrock/composer.json; \
    \
    su -c "cd ${OPENLITESPEED_CONFIG}/bedrock && composer update; \
    \
    composer clearcache" -s /bin/sh demyx; \
    \
    cp -r "$OPENLITESPEED_CONFIG"/bedrock/. "$OPENLITESPEED_ROOT"; \
    chown -R demyx:demyx "$OPENLITESPEED_ROOT"

# Copy source
COPY --chown=demyx:demyx src "$OPENLITESPEED_CONFIG"

# Finalize
RUN set -ex; \
    chmod +x "$OPENLITESPEED_CONFIG"/config.sh; \
    chmod +x "$OPENLITESPEED_CONFIG"/install.sh; \
    chmod +x /usr/local/bin/demyx-install; \
    \
    mv "$OPENLITESPEED_CONFIG"/install.sh /usr/local/bin/demyx-install

USER demyx
