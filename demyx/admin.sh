#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Set base path for the admin ui
# Ex: https://domain.tld/demyx/ols/
OPENLITESPEED_ADMIN="${OPENLITESPEED_ADMIN:-/demyx/ols}"

# Disable prefix if this variable is false
if [[ "$OPENLITESPEED_ADMIN_PREFIX" = true ]]; then
  find /usr/local/lsws/admin/html/. -type f -print0 | xargs -0 sed -i "s|/login.php|${OPENLITESPEED_ADMIN}/login.php|g"
  find /usr/local/lsws/admin/html/. -type f -print0 | xargs -0 sed -i "s|/index.php|${OPENLITESPEED_ADMIN}/index.php|g"
fi

# Replace default OLS admin login
# Default username: demyx
# Default password: demyx
OPENLITESPEED_ADMIN_PASSWORD_ENCRYPTED="$(demyx-encrypt "$OPENLITESPEED_ADMIN_PASSWORD")"
echo "${OPENLITESPEED_ADMIN_USERNAME}:${OPENLITESPEED_ADMIN_PASSWORD_ENCRYPTED}" > /usr/local/lsws/admin/conf/htpasswd
chown lsadm:lsadm /usr/local/lsws/admin/conf/htpasswd
chmod 600 /usr/local/lsws/admin/conf/htpasswd
