#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Default to null of first argument is missing
OPENLITESPEED_ENCRYPT_PASSWORD="${1:-}"

# Exit script if empty
if [[ -z "$OPENLITESPEED_ENCRYPT_PASSWORD" ]]; then
    echo "First argument requires a value!"
    exit 1
fi

# Encrypt password using OLS core script
OPENLITESPEED_ENCRYPT="$(/usr/local/lsws/admin/fcgi-bin/admin_php -q /usr/local/lsws/admin/misc/htpasswd.php "$OPENLITESPEED_ENCRYPT_PASSWORD")"

# Output encrypted password
echo "$OPENLITESPEED_ENCRYPT"
