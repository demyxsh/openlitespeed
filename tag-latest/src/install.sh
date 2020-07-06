#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Define variables
WORDPRESS_DB_NAME="${WORDPRESS_DB_NAME:-}"
WORDPRESS_DB_USER="${WORDPRESS_DB_USER:-}"
WORDPRESS_DB_PASSWORD="${WORDPRESS_DB_PASSWORD:-}"
WORDPRESS_DB_HOST="${WORDPRESS_DB_HOST:-}"
WORDPRESS_WP_CONFIG="$OPENLITESPEED_ROOT"/wp-config.php

if [[ ! -d "$OPENLITESPEED_ROOT"/wp-content ]]; then
    echo "[demyx] WordPress is missing, copying files now ..."
    cp -r "$OPENLITESPEED_CONFIG"/wordpress/* "$OPENLITESPEED_ROOT"
fi

if [[ ! -f "$OPENLITESPEED_ROOT"/wp-config.php ]]; then
    echo "[demyx] Generating wp-config.php ..."
    cp "$OPENLITESPEED_ROOT"/wp-config-sample.php "$WORDPRESS_WP_CONFIG"
fi

if [[ -n "$(grep database_name_here "$WORDPRESS_WP_CONFIG" || true)" && "$WORDPRESS_DB_NAME" && "$WORDPRESS_DB_USER" && "$WORDPRESS_DB_PASSWORD" && "$WORDPRESS_DB_HOST" ]]; then
    echo "[demyx] Configuring wp-config.php ..."
    sed -i "s|database_name_here|${WORDPRESS_DB_NAME}|g" "$WORDPRESS_WP_CONFIG"
    sed -i "s|username_here|${WORDPRESS_DB_USER}|g" "$WORDPRESS_WP_CONFIG"
    sed -i "s|password_here|${WORDPRESS_DB_PASSWORD}|g" "$WORDPRESS_WP_CONFIG"
    sed -i "s|localhost|${WORDPRESS_DB_HOST}|g" "$WORDPRESS_WP_CONFIG"
    SALT="$(wget -qO- https://api.wordpress.org/secret-key/1.1/salt/)"
    printf '%s\n' "g/put your unique phrase here/d" a "$SALT" . w | ed -s "$WORDPRESS_WP_CONFIG"
    sed -i "s|\$table_prefix = 'wp_';|\$table_prefix = 'wp_';\n\n\/\/ If we're behind a proxy server and using HTTPS, we need to alert Wordpress of that fact\n\/\/ see also http:\/\/codex.wordpress.org\/Administration_Over_SSL#Using_a_Reverse_Proxy\nif (isset($\_SERVER['HTTP_X_FORWARDED_PROTO']) \&\& $\_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {\n\t$\_SERVER['HTTPS'] = 'on';\n}\n|g" "$WORDPRESS_WP_CONFIG"
fi
