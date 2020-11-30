#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Support for old variables
[[ -n "${OPENLITESPEED_ADMIN:-}" ]] && DEMYX_ADMIN="$OPENLITESPEED_ADMIN"
[[ -n "${OPENLITESPEED_ADMIN_PREFIX:-}" ]] && DEMYX_ADMIN_PREFIX="$OPENLITESPEED_ADMIN_PREFIX"
[[ -n "${OPENLITESPEED_ADMIN_PASSWORD:-}" ]] && DEMYX_ADMIN_PASSWORD="$OPENLITESPEED_ADMIN_PASSWORD"
[[ -n "${OPENLITESPEED_ADMIN_USERNAME:-}" ]] && DEMYX_ADMIN_USERNAME="$OPENLITESPEED_ADMIN_USERNAME"

# Disable prefix if this variable is false
if [[ "$DEMYX_ADMIN_PREFIX" = true ]]; then
    /usr/bin/find /usr/local/lsws/admin/html/. -type f -print0 | /usr/bin/xargs -0 /bin/sed -i "s|/login.php|${DEMYX_ADMIN}/login.php|g"
    /usr/bin/find /usr/local/lsws/admin/html/. -type f -print0 | /usr/bin/xargs -0 /bin/sed -i "s|/index.php|${DEMYX_ADMIN}/index.php|g"
fi

# Replace default OLS admin login
# Default username: demyx
# Default password: demyx
DEMYX_ADMIN_PASSWORD_ENCRYPTED="$(demyx-encrypt "$DEMYX_ADMIN_PASSWORD")"
/bin/echo "${DEMYX_ADMIN_USERNAME}:${DEMYX_ADMIN_PASSWORD_ENCRYPTED}" > /usr/local/lsws/admin/conf/htpasswd
/bin/chown lsadm:lsadm /usr/local/lsws/admin/conf/htpasswd
/bin/chmod 600 /usr/local/lsws/admin/conf/htpasswd
