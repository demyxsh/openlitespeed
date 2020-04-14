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
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Bedrock
RUN set -ex; \
    su -c "composer create-project roots/bedrock ${OPENLITESPEED_CONFIG}/bedrock; \
    \
    cd ${OPENLITESPEED_CONFIG}/bedrock && composer update; \
    \
    composer clearcache; \
    \
    tar -czf ${OPENLITESPEED_CONFIG}/bedrock.tgz -C ${OPENLITESPEED_CONFIG} bedrock; \
    \
    rm -rf ${OPENLITESPEED_CONFIG}/bedrock" -s /bin/sh demyx

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
