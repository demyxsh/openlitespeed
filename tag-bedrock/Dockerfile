FROM demyx/openlitespeed

LABEL sh.demyx.image demyx/openlitespeed:bedrock
LABEL sh.demyx.maintainer Demyx <info@demyx.sh>
LABEL sh.demyx.url https://demyx.sh
LABEL sh.demyx.github https://github.com/demyxco
LABEL sh.demyx.registry https://hub.docker.com/u/demyx

# Default bedrock to production
ENV WORDPRESS_BEDROCK_MODE=production

# Need root stuff
USER root

# Bedrock
RUN set -ex; \
    # Bedrock install deps
    OPENLITESPEED_BEDROCK_DEPS="php7.3 php7.3-zip php7.3-xml unzip"; \
    \
    apt-get update && apt-get install -y --no-install-recommends composer git ${OPENLITESPEED_BEDROCK_DEPS}; \
    \
    su -c "composer create-project roots/bedrock ${OPENLITESPEED_CONFIG}/bedrock; composer clearcache" -s /bin/sh demyx; \
    tar -czf "$OPENLITESPEED_CONFIG"/bedrock.tgz -C "$OPENLITESPEED_CONFIG" bedrock; \
    rm -rf "$OPENLITESPEED_CONFIG"/bedrock; \
    \
    apt-get purge --auto-remove -y ${OPENLITESPEED_BEDROCK_DEPS}

# Copy files
COPY --chown=demyx:demyx demyx/. "$OPENLITESPEED_CONFIG"
COPY demyx.sh /usr/local/bin/demyx

# Finalize
RUN set -ex; \
    chmod +x "$OPENLITESPEED_CONFIG"/config.sh; \
    chmod +x "$OPENLITESPEED_CONFIG"/install.sh; \
    chmod +x /usr/local/bin/demyx-install; \
    chmod +x /usr/local/bin/demyx; \
    \
    mv "$OPENLITESPEED_CONFIG"/install.sh /usr/local/bin/demyx-install

USER demyx
