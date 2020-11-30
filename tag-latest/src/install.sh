#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Support for old variables
[[ -n "${WORDPRESS_DB_HOST:-}" ]] && DEMYX_DB_HOST="$WORDPRESS_DB_HOST"
[[ -n "${WORDPRESS_DB_NAME:-}" ]] && DEMYX_DB_NAME="$WORDPRESS_DB_NAME"
[[ -n "${WORDPRESS_DB_PASSWORD:-}" ]] && DEMYX_DB_PASSWORD="$WORDPRESS_DB_PASSWORD"
[[ -n "${WORDPRESS_DB_USER:-}" ]] && DEMYX_DB_USER="$WORDPRESS_DB_USER"

if [[ ! -d "$DEMYX"/wp-content ]]; then
    /bin/echo "[demyx] WordPress is missing, copying files now ..."
    /bin/cp -r "$DEMYX_CONFIG"/wordpress/* "$DEMYX"
fi

if [[ ! -f "$DEMYX"/wp-config.php ]]; then
    /bin/echo "[demyx] Generating wp-config.php ..."
    /bin/cp "$DEMYX"/wp-config-sample.php "$DEMYX_WP_CONFIG"
fi

if [[ -n "$(/bin/grep database_name_here "$DEMYX_WP_CONFIG" || true)" && "$DEMYX_DB_NAME" && "$DEMYX_DB_USER" && "$DEMYX_DB_PASSWORD" && "$DEMYX_DB_HOST" ]]; then
    /bin/echo "[demyx] Configuring wp-config.php ..."
    /bin/sed -i "s|database_name_here|${DEMYX_DB_NAME}|g" "$DEMYX_WP_CONFIG"
    /bin/sed -i "s|username_here|${DEMYX_DB_USER}|g" "$DEMYX_WP_CONFIG"
    /bin/sed -i "s|password_here|${DEMYX_DB_PASSWORD}|g" "$DEMYX_WP_CONFIG"
    /bin/sed -i "s|localhost|${DEMYX_DB_HOST}|g" "$DEMYX_WP_CONFIG"
    SALT="$(wget -qO- https://api.wordpress.org/secret-key/1.1/salt/)"
    /usr/bin/printf '%s\n' "g/put your unique phrase here/d" a "$SALT" . w | /bin/ed -s "$DEMYX_WP_CONFIG"
    /bin/sed -i "s|\$table_prefix = 'wp_';|\$table_prefix = 'wp_';\n\n\/\/ If we're behind a proxy server and using HTTPS, we need to alert Wordpress of that fact\n\/\/ see also http:\/\/codex.wordpress.org\/Administration_Over_SSL#Using_a_Reverse_Proxy\nif (isset($\_SERVER['HTTP_X_FORWARDED_PROTO']) \&\& $\_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {\n\t$\_SERVER['HTTPS'] = 'on';\n}\n|g" "$DEMYX_WP_CONFIG"
fi
