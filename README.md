# openlitespeed
[![Build Status](https://img.shields.io/travis/demyxco/openlitespeed?style=flat)](https://travis-ci.org/demyxco/openlitespeed)
[![Docker Pulls](https://img.shields.io/docker/pulls/demyx/openlitespeed?style=flat&color=blue)](https://hub.docker.com/r/demyx/openlitespeed)
[![Architecture](https://img.shields.io/badge/linux-amd64-important?style=flat&color=blue)](https://hub.docker.com/r/demyx/openlitespeed)
[![Debian](https://img.shields.io/badge/debian-10.8-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/openlitespeed)
[![OpenLiteSpeed](https://img.shields.io/badge/openlitespeed-1.6.20-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/openlitespeed)
[![lsphp](https://img.shields.io/badge/lsphp-7.4.15-informational?style=flat&color=blue)](https://hub.docker.com/r/demyx/openlitespeed)
[![Buy Me A Coffee](https://img.shields.io/badge/buy_me_coffee-$5-informational?style=flat&color=blue)](https://www.buymeacoffee.com/VXqkQK5tb)
[![Become a Patron!](https://img.shields.io/badge/become%20a%20patron-$5-informational?style=flat&color=blue)](https://www.patreon.com/bePatron?u=23406156)

Non-root Docker image running Debian and OpenLiteSpeed.

DEMYX | OPENLITESPEED
--- | ---
TAGS | latest bedrock
PORT | 80 8080
USER | demyx
WORKDIR | /demyx
CONFIG | /etc/demyx
LOG | /var/log/demyx
ENTRYPOINT | /usr/local/bin/demyx-entrypoint
WORDPRESS | https://domain.tld/
OPENLITESPEED | https://domain.tld/demyx/ols/

## Usage
- `DEMYX_ADMIN_IP=myip` to lock down OpenLiteSpeed's admin page
- `DEMYX_ADMIN_PREFIX=false` if you're exposing ports
- `DEMYX_BASIC_AUTH_WP=true` to enable basic auth for wp-login.php
- `DEMYX_XMLRPC=true` to enable xmlrpc.php

```
# Demyx
# https://demyx.sh
#
# This docker-compose.yml is designed for VPS use with SSL/TLS first.
# Traefik requires no additional configurations and is ready to go.
# Be sure to change all the domain.tld domains and credentials before running docker-compose up -d.
#
networks:
  demyx:
    name: demyx
  demyx_socket:
    name: demyx_socket
services:
  demyx_db:
    container_name: demyx_db
    depends_on:
      - demyx_traefik
    environment:
      - DEMYX=/demyx
      - DEMYX_CHARACTER_SET_SERVER=utf8
      - DEMYX_COLLATION_SERVER=utf8_general_ci
      - DEMYX_CONFIG=/etc/demyx
      - DEMYX_DATABASE=demyx
      - DEMYX_DEFAULT_CHARACTER_SET=utf8
      - DEMYX_DOMAIN=domain.tld
      - DEMYX_INNODB_BUFFER_POOL_SIZE=16M
      - DEMYX_INNODB_DATA_FILE_PATH=ibdata1:10M:autoextend
      - DEMYX_INNODB_FILE_PER_TABLE=1
      - DEMYX_INNODB_FLUSH_LOG_AT_TRX_COMMIT=1
      - DEMYX_INNODB_LOCK_WAIT_TIMEOUT=50
      - DEMYX_INNODB_LOG_BUFFER_SIZE=8M
      - DEMYX_INNODB_LOG_FILE_SIZE=5M
      - DEMYX_INNODB_USE_NATIVE_AIO=1
      - DEMYX_KEY_BUFFER_SIZE=20M
      - DEMYX_LOG=/var/log/demyx
      - DEMYX_MAX_ALLOWED_PACKET=16M
      - DEMYX_MAX_CONNECTIONS=1000
      - DEMYX_MYISAM_SORT_BUFFER_SIZE=8M
      - DEMYX_NET_BUFFER_SIZE=8K
      - DEMYX_PASSWORD=demyx
      - DEMYX_READ_BUFFER=2M
      - DEMYX_READ_BUFFER_SIZE=256K
      - DEMYX_READ_RND_BUFFER_SIZE=512K
      - DEMYX_ROOT_PASSWORD=demyx_root  # Mandatory
      - DEMYX_SERVER_ID=1
      - DEMYX_SORT_BUFFER_SIZE=20M
      - DEMYX_TABLE_OPEN_CACHE=64
      - DEMYX_USERNAME=demyx
      - DEMYX_WRITE_BUFFER=2M
      - TZ=America/Los_Angeles
    image: demyx/mariadb
    networks:
      - demyx
    restart: unless-stopped
    volumes:
      - demyx_db:/demyx
      - demyx_log:/var/log/demyx
  demyx_socket:
    container_name: demyx_socket
    environment:
      - CONTAINERS=1
    image: demyx/docker-socket-proxy
    networks:
      - demyx_socket
    # Uncomment below if your host OS is CentOS/RHEL/Fedora
    #privileged: true
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
  demyx_traefik:
    container_name: demyx_traefik
    depends_on:
      - demyx_socket
    environment:
      # Uncomment below for Cloudflare DNS challenge
      #- CF_API_EMAIL=info@domain.tld
      #- CF_API_KEY=123456
      - DEMYX_ACME_EMAIL=info@domain.tld
      - DEMYX_TRAEFIK_LOG=INFO
      - TRAEFIK_PROVIDERS_DOCKER_ENDPOINT=tcp://demyx_socket:2375
    image: demyx/traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.middlewares.traefik-auth.basicauth.users=demyx:$$apr1$$L91z3CIR$$m/BKZcnQGBP.Uo2cJm8I0/" # Password: demyx
      - "traefik.http.middlewares.traefik-redirect.redirectscheme.scheme=https"
      - "traefik.http.routers.traefik-http.entrypoints=http"
      - "traefik.http.routers.traefik-http.middlewares=traefik-redirect"
      - "traefik.http.routers.traefik-http.rule=Host(`traefik.domain.tld`)"
      - "traefik.http.routers.traefik-http.service=traefik-http-port"
      - "traefik.http.routers.traefik-https.entrypoints=https"
      - "traefik.http.routers.traefik-https.middlewares=traefik-auth"
      - "traefik.http.routers.traefik-https.rule=Host(`traefik.domain.tld`)" # https://traefik.domain.tld
      - "traefik.http.routers.traefik-https.service=api@internal"
      - "traefik.http.routers.traefik-https.service=traefik-https-port"
      - "traefik.http.routers.traefik-https.tls.certresolver=demyx"
      - "traefik.http.services.traefik-http-port.loadbalancer.server.port=8080"
      - "traefik.http.services.traefik-https-port.loadbalancer.server.port=8080"
    networks:
      - demyx
      - demyx_socket
    ports:
      - 80:8081
      - 443:8082
    restart: unless-stopped
    volumes:
      - demyx_log:/var/log/demyx
      - demyx_traefik:/demyx
  demyx_wp:
    container_name: demyx_wp
    depends_on:
      - demyx_db
    environment:
      - DEMYX=/demyx
      - DEMYX_ADMIN=/demyx/ols
      - DEMYX_ADMIN_IP=ALL
      - DEMYX_ADMIN_PASSWORD=demyx
      - DEMYX_ADMIN_PREFIX=true
      - DEMYX_ADMIN_USERNAME=demyx
      - DEMYX_BASIC_AUTH_PASSWORD=demyx
      - DEMYX_BASIC_AUTH_USERNAME=demyx
      - DEMYX_BASIC_AUTH_WP=false
      - DEMYX_CACHE=false
      - DEMYX_CLIENT_THROTTLE_BANDWIDTH_IN=0
      - DEMYX_CLIENT_THROTTLE_BANDWIDTH_OUT=0
      - DEMYX_CLIENT_THROTTLE_BAN_PERIOD=60
      - DEMYX_CLIENT_THROTTLE_BLOCK_BAD_REQUEST=1
      - DEMYX_CLIENT_THROTTLE_DYNAMIC=1000
      - DEMYX_CLIENT_THROTTLE_GRACE_PERIOD=30
      - DEMYX_CLIENT_THROTTLE_HARD_LIMIT=2000
      - DEMYX_CLIENT_THROTTLE_SOFT_LIMIT=1500
      - DEMYX_CLIENT_THROTTLE_STATIC=1000
      - DEMYX_CONFIG=/etc/demyx
      - DEMYX_CRAWLER_LOAD_LIMIT=5.2
      - DEMYX_CRAWLER_USLEEP=1000
      - DEMYX_DB_HOST=demyx_db
      - DEMYX_DB_NAME=demyx
      - DEMYX_DB_PASSWORD=demyx
      - DEMYX_DB_USER=demyx
      - DEMYX_DOMAIN=domain.tld
      - DEMYX_LOG=/var/log/demyx
      - DEMYX_LSPHP_VERSION=lsphp74
      - DEMYX_PHP_LSAPI_CHILDREN=2000
      - DEMYX_PHP_MAX_EXECUTION_TIME=300
      - DEMYX_PHP_MEMORY=256M
      - DEMYX_PHP_OPCACHE=true
      - DEMYX_PHP_UPLOAD_LIMIT=128M
      - DEMYX_RECAPTCHA_CONNECTION_LIMIT=500
      - DEMYX_RECAPTCHA_ENABLE=1
      - DEMYX_RECAPTCHA_TYPE=2
      - DEMYX_TUNING_CONNECTION_TIMEOUT=300
      - DEMYX_TUNING_KEEP_ALIVE_TIMEOUT=300
      - DEMYX_TUNING_MAX_CONNECTIONS=20000
      - DEMYX_TUNING_MAX_KEEP_ALIVE=1000
      - DEMYX_TUNING_SMART_KEEP_ALIVE=1000
      - DEMYX_WP_CONFIG=/demyx/wp-config.php
      - DEMYX_XMLRPC=false
    image: demyx/openlitespeed
    labels:
      - "traefik.enable=true"
      - "traefik.http.middlewares.demyx-wp-ols-assets-prefix.stripprefix.prefixes=/demyx/ols/"
      - "traefik.http.middlewares.demyx-wp-ols-prefix.stripprefix.prefixes=/demyx/ols/"
      - "traefik.http.middlewares.demyx-wp-redirect.redirectregex.permanent=true"
      - "traefik.http.middlewares.demyx-wp-redirect.redirectregex.regex=^https?:\/\/(?:www\\.)?(.+)"
      - "traefik.http.middlewares.demyx-wp-redirect.redirectregex.replacement=https://$${1}"
      - "traefik.http.routers.demyx-wp-http.entrypoints=http"
      - "traefik.http.routers.demyx-wp-http.middlewares=demyx-wp-redirect"
      - "traefik.http.routers.demyx-wp-http.rule=Host(`domain.tld`) || Host(`www.domain.tld`)"
      - "traefik.http.routers.demyx-wp-http.service=demyx-wp-http-port"
      - "traefik.http.routers.demyx-wp-https.entrypoints=https"
      - "traefik.http.routers.demyx-wp-https.rule=Host(`domain.tld`) || Host(`www.domain.tld`)" # https://domain.tld
      - "traefik.http.routers.demyx-wp-https.service=demyx-wp-https-port"
      - "traefik.http.routers.demyx-wp-https.tls.certresolver=demyx"
      - "traefik.http.routers.demyx-wp-ols-assets.entrypoints=https"
      - "traefik.http.routers.demyx-wp-ols-assets.priority=99"
      - "traefik.http.routers.demyx-wp-ols-assets.rule=Host(`domain.tld`) && PathPrefix(`/res/`)"
      - "traefik.http.routers.demyx-wp-ols-assets.service=demyx-wp-ols-assets-port"
      - "traefik.http.routers.demyx-wp-ols-assets.tls.certresolver=demyx"
      - "traefik.http.routers.demyx-wp-ols.entrypoints=https"
      - "traefik.http.routers.demyx-wp-ols.middlewares=demyx-wp-ols-prefix"
      - "traefik.http.routers.demyx-wp-ols.priority=99"
      - "traefik.http.routers.demyx-wp-ols.rule=Host(`domain.tld`) && PathPrefix(`/demyx/ols/`)" # https://domain.tld/demyx/ols/
      - "traefik.http.routers.demyx-wp-ols.service=demyx-wp-ols-port"
      - "traefik.http.routers.demyx-wp-ols.tls.certresolver=demyx"
      - "traefik.http.services.demyx-wp-http-port.loadbalancer.server.port=80"
      - "traefik.http.services.demyx-wp-https-port.loadbalancer.server.port=80"
      - "traefik.http.services.demyx-wp-ols-assets-port.loadbalancer.server.port=8080"
      - "traefik.http.services.demyx-wp-ols-port.loadbalancer.server.port=8080"
    networks:
      - demyx
    restart: unless-stopped
    volumes:
      - demyx_wp:/demyx
      - demyx_log:/var/log/demyx
version: "2.4"
volumes:
  demyx_db:
    name: demyx_db
  demyx_log:
    name: demyx_log
  demyx_traefik:
    name: demyx_traefik
  demyx_wp:
    name: demyx_wp
```

## Updates & Support
[![Code Size](https://img.shields.io/github/languages/code-size/demyxco/openlitespeed?style=flat&color=blue)](https://github.com/demyxco/openlitespeed)
[![Repository Size](https://img.shields.io/github/repo-size/demyxco/openlitespeed?style=flat&color=blue)](https://github.com/demyxco/openlitespeed)
[![Watches](https://img.shields.io/github/watchers/demyxco/openlitespeed?style=flat&color=blue)](https://github.com/demyxco/openlitespeed)
[![Stars](https://img.shields.io/github/stars/demyxco/openlitespeed?style=flat&color=blue)](https://github.com/demyxco/openlitespeed)
[![Forks](https://img.shields.io/github/forks/demyxco/openlitespeed?style=flat&color=blue)](https://github.com/demyxco/openlitespeed)

* Auto built weekly on Saturdays (America/Los_Angeles)
* Rolling release updates
* For support: [#demyx](https://webchat.freenode.net/?channel=#demyx)
