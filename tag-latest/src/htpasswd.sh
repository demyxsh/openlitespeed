#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Encrypt basic auth password
# Default username: demyx
# Default password: demyx
DEMYX_BASIC_AUTH_PASSWORD_ENCRYPTED="$(/usr/local/bin/demyx-encrypt "$DEMYX_BASIC_AUTH_PASSWORD")"
/bin/echo "${DEMYX_BASIC_AUTH_USERNAME}:${DEMYX_BASIC_AUTH_PASSWORD_ENCRYPTED}" > "$DEMYX_CONFIG"/ols/htpasswd
/bin/chown nobody:nogroup "$DEMYX_CONFIG"/ols/htpasswd
/bin/chmod 600 "$DEMYX_CONFIG"/ols/htpasswd
