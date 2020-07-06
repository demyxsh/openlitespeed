#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Define variables
WORDPRESS_DOMAIN="${OPENLITESPEED_DOMAIN:-domain.tld}"
WORDPRESS_SSL="${WORDPRESS_SSL:-false}"
WORDPRESS_DB_NAME="${WORDPRESS_DB_NAME:-}"
WORDPRESS_DB_USER="${WORDPRESS_DB_USER:-}"
WORDPRESS_DB_PASSWORD="${WORDPRESS_DB_PASSWORD:-}"
WORDPRESS_DB_HOST="${WORDPRESS_DB_HOST:-}"
WORDPRESS_ENV="$OPENLITESPEED_ROOT"/.env
WORDPRESS_PROTO="http://$WORDPRESS_DOMAIN"
[[ "$WORDPRESS_SSL" = true ]] && WORDPRESS_PROTO="https://$WORDPRESS_DOMAIN"

if [[ ! -d "$OPENLITESPEED_ROOT"/web ]]; then
    echo "[demyx] Bedrock is missing, copying files now ..."
    cp -r "$OPENLITESPEED_CONFIG"/bedrock/. "$OPENLITESPEED_ROOT"
fi

if [[ ! -f "$WORDPRESS_ENV" ]]; then
    echo "[demyx] Generating Bedrock .env file ..."
    cp "$OPENLITESPEED_CONFIG"/bedrock/.env "$OPENLITESPEED_ROOT"
fi

if [[ -n "$(grep example.com "$WORDPRESS_ENV" || true)" && -n "$WORDPRESS_DB_NAME" && -n "$WORDPRESS_DB_USER" && -n "$WORDPRESS_DB_PASSWORD" && -n "$WORDPRESS_DB_HOST" && -n "$WORDPRESS_DOMAIN" ]]; then
    echo "[demyx] Configuring Bedrock .env file ..."
    sed -i "s|WP_HOME=.*|WP_HOME=$WORDPRESS_PROTO|g" "$WORDPRESS_ENV"
    sed -i "s|database_name|$WORDPRESS_DB_NAME|g" "$WORDPRESS_ENV"
    sed -i "s|database_user|$WORDPRESS_DB_USER|g" "$WORDPRESS_ENV"
    sed -i "s|database_password|$WORDPRESS_DB_PASSWORD|g" "$WORDPRESS_ENV"
    sed -i "s|# DB_HOST='localhost'|DB_HOST='$WORDPRESS_DB_HOST'|g" "$WORDPRESS_ENV"
    sed -i "s|WP_ENV=.*|WP_ENV=production|g" "$WORDPRESS_ENV"
    SALT="$(wget -qO- https://api.wordpress.org/secret-key/1.1/salt/ | sed "s|define('||g" | sed "s|',|=|g" | sed "s| ||g" | sed "s|);||g")"
    printf '%s\n' "g/generateme/d" a "$SALT" . w | ed -s "$WORDPRESS_ENV"
fi
